TESTS             = $(shell find tests -type f -name test-*)

-COVERAGE_DIR    := out/test/
-RELEASE_DIR     := out/release/

-COVERAGE_COPY   := lib node_modules etc tests
-RELEASE_COPY    := lib statics node_modules etc tests

-BIN_MOCHA       := ./node_modules/.bin/mocha
-BIN_JSCOVER     := ./node_modules/.bin/jscover
-BIN_ISTANBUL    := ./node_modules/.bin/istanbul

-TESTS           := $(sort $(TESTS))

-COFFEE_LIB      := $(shell find lib -type f -name '*.coffee')
-COFFEE_TEST     := $(shell find tests -type f -name 'test-*.coffee')
-COFFEE_TEST_LIB := $(shell find tests -type f -name '*.coffee')

#coffee compile
-BIN_COFFEE      := ./node_modules/coffee-script/bin/coffee
-COFFEE_COVERAGE := $(-COFFEE_LIB)
-COFFEE_COVERAGE += $(-COFFEE_TEST)
-COFFEE_COVERAGE += $(-COFFEE_TEST_LIB)
-COFFEE_COVERAGE := $(filter-out $(-COMPILE-IGNORE), $(-COFFEE_COVERAGE))
-COFFEE_RELEASE  := $(addprefix $(-RELEASE_DIR),$(-COFFEE_COVERAGE) )
-COFFEE_COVERAGE := $(addprefix $(-COVERAGE_DIR),$(-COFFEE_COVERAGE) )

-COVERAGE_FILE   := coverage.html

-COVERAGE_TESTS  := $(addprefix $(-COVERAGE_DIR),$(-TESTS))
-COVERAGE_TESTS  := $(-COVERAGE_TESTS:.coffee=.js)

-TESTS_ENV       := tests/env.js
-COVERAGE_ENV    := $(addprefix $(-COVERAGE_DIR),$(-TESTS_ENV))

-LOGS_DIR        := logs

-GIT_REV         := $(shell git show | head -n1 | cut -f 2 -d ' ')
-GIT_REV         := $(shell echo "print substr('$(-GIT_REV)', 0, 8);" | /usr/bin/env perl)

default: dev

-common-pre: clean -npm-install -logs

dev: -common-pre
	@$(-BIN_MOCHA) \
		--colors \
		--compilers coffee:coffee-script/register \
		--reporter spec \
		--growl \
		--require $(-TESTS_ENV) \
		$(-TESTS)

test: -common-pre
	@$(-BIN_MOCHA) \
		--no-colors \
		--compilers coffee:coffee-script/register \
		--reporter tap \
		--require $(-TESTS_ENV) \
		$(-TESTS)

-pre-test-cov: -common-pre
	@echo 'copy files'
	@mkdir -p $(-COVERAGE_DIR)

	@rsync -av . $(-COVERAGE_DIR) --exclude out --exclude .git --exclude node_modules
	@rsync -av ./node_modules $(-COVERAGE_DIR)
	@$(-BIN_COFFEE) -cb out/test
	@find ./out/test -path ./out/test/node_modules -prune -o -name "*.coffee" -exec rm -rf {} \;

test-cov: -pre-test-cov
	@cd $(-COVERAGE_DIR) && \
		$(-BIN_ISTANBUL) cover ./node_modules/.bin/_mocha -- -u bdd -R tap -r $(-TESTS_ENV) $(patsubst $(-COVERAGE_DIR)%, %, $(-COVERAGE_TESTS)) && \
	  $(-BIN_ISTANBUL) report html
	

-release-pre : -common-pre
	@echo 'copy files'
	@mkdir -p $(-RELEASE_DIR)

	@if [ `echo $$OSTYPE | grep -c 'darwin'` -eq 1 ]; then \
		cp -r $(-RELEASE_COPY) $(-RELEASE_DIR); \
	else \
		cp -rL $(-RELEASE_COPY) $(-RELEASE_DIR); \
	fi
	@echo $(-GIT_REV)
	@cd $(-RELEASE_DIR)

	@cp package.json $(-RELEASE_DIR)

	@cd $(-RELEASE_DIR) && PYTHON=`which python2.6` npm --color=false --registry=http://registry.npm.taobao.net install --production


release: -release-pre
	@rm -fr $(-RELEASE_DIR)/tests
	@echo "all codes in \"$(-RELEASE_DIR)\""

.-PHONY: default

-npm-install:
	@npm --color=false --registry=http://registry.npm.taobao.net install

clean:
	@echo 'clean'
	@-rm -fr out
	@-rm -fr $(-LOGS_DIR)

-logs:
	@mkdir -p $(-LOGS_DIR)