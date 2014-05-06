
# /*
#   Spies: and.stub
#   When a calling strategy is used for a spy, the original stubbing 
#   behavior can be returned at any time with and.stub.
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 15:57:05 GMT+0800 (CST)
# */
#

"use strict"

expect = require 'expect.js'
jmspy  = require '../index.js'

describe "A spy", ->
  foo = null
  bar = null
  spy = null

  beforeEach ->
    foo =
      setBar: ( value ) ->
        bar = value

    spy = jmspy.spyOn( foo, 'setBar' ).and.callThrough()

  it "can call through and then stub in the same spec", ( done ) ->
    foo.setBar 123
    expect( bar ).to.be 123

    foo.setBar.and.stub()
    bar = null

    foo.setBar 123
    expect( bar ).to.be null
    done()
