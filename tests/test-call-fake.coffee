
# /*
#   Spies: and.callFake
#   By chaining the spy with and.callFake, 
#   all calls to the spy will delegate to the supplied function.
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 15:57:05 GMT+0800 (CST)
# */
#

"use strict"

expect = require 'expect.js'
jmspy  = require '../index.js'

describe "A spy, when configured with an alternate implementation", ->
  foo        = null
  spy        = null
  bar        = null
  fetchedBar = null

  beforeEach ->
    foo = 
      setBar: ( value ) ->
        bar = value
      getBar: ->
        bar

    spy = jmspy.spyOn( foo, "getBar" ).and.callFake ->
      1001

    foo.setBar 123
    fetchedBar = foo.getBar()

  it "tracks that the spy was called", ( done ) ->
    expect( spy.calls.any() ).to.be.ok()
    done()

  it "should not effect other functions", ( done ) ->
    expect( bar ).to.be 123
    done()

  it "when called returns the requested value", ( done ) ->
    expect( fetchedBar ).to.be 1001
    done()
