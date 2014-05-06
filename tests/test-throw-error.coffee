
# /*
#   Spies: and.throwError
#   By chaining the spy with and.throwError, 
#   all calls to the spy will throw the specified value as an error.
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 15:57:05 GMT+0800 (CST)
# */
#

"use strict"

expect = require 'expect.js'
jmspy  = require '../index.js'

describe "A spy, when configured to throw an error", ->
  foo = null
  bar = null
  spy = null

  beforeEach ->
    foo =
      setBar: ( value ) ->
        bar = value

    spy = jmspy.spyOn( foo, "setBar" ).and.throwError "quux"

  it "throws the value", ( done ) ->
    try
      foo.setBar 123
    catch e
      expect( e.message ).to.be "quux"
    done()

  it "throws an error", ( done ) ->
    foo =
      setBar: ( value ) ->
        bar = value

    spy = jmspy.spyOn( foo, "setBar" ).and.throwError new Error "quux"
    try
      foo.setBar 123
    catch e
      expect( e.message ).to.be 'quux'
      done()
