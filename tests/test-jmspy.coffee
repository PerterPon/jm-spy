
# /*
#   Spies
#   Jasmine’s has test double functions called spies. 
#   A spy can stub any function and tracks calls to it and all arguments. 
#   A spy only exists in the describe or it block it is defined, 
#   and will be removed after each spec. 
#   There are special matchers for interacting with spies. 
#   This syntax has changed for Jasmine 2.0. 
#   The toHaveBeenCalled matcher will return true if the spy was called. 
#   The toHaveBeenCalledWith matcher will return true 
#   if the argument list matches any of the recorded calls to the spy.
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 15:57:05 GMT+0800 (CST)
# */
#

"use strict"

expect = require 'expect.js'
jmspy  = require '../index.js'

describe "A spy", () ->
  foo = null
  bar = null
  spy = null

  beforeEach () ->
    foo =
      setBar: ( value ) ->
        bar = value

    spy = jmspy.spyOn foo, 'setBar'

    foo.setBar 123 
    foo.setBar 456, 'another param'

  it "tracks that the spy was called", ( done ) ->
    expect( spy.calls.any() ).to.be.ok()
    done()

  it "tracks all the arguments of its calls", ( done ) ->
    calledArgs = []
    calledArgs = spy.calls.allArgs()
    expect( calledArgs[ 0 ] ).to.eql [ 123 ]
    expect( calledArgs[ 1 ] ).to.eql [ 456, "another param" ]
    done()

  it "stops all execution on a function", ( done ) ->
    expect( bar ).to.be null
    done()

  it 'track a method whitch obj is not defined', ( done ) ->
    try
      jmspy.spyOn undefined, 'test'
    catch e
      expect( e.message ).to.be 'spyOn could not find an object to spy upon for test()'
      done()

  it 'tracks a method witch is not exists', ( done ) ->
    try
      jmspy.spyOn foo, 'unknowmethod'
    catch e
      expect( e.message ).to.be 'unknowmethod() method does not exist'
      done()

  it 'tracks a method but it has already spied upon', ( done ) ->
    try
      jmspy.spyOn foo, 'setBar'
    catch e
      expect( e.message ).to.be 'setBar has already been spied upon'
      done()

  it 'call isSpy method with undefined argument', ( done ) ->
    expect( jmspy.isSpy() ).not.to.be.ok()
    done()

  it 'call argsFor when spied method not called', ( done ) ->
    foo = 
      setBar : ->
    spy = jmspy.spyOn foo, 'setBar'
    expect( spy.calls.argsFor 1 ).to.eql []
    done()

  it 'call argsFor when create spy call none argunemts', ( done ) ->
    spy = jmspy.createSpy()
    expect( spy.calls.argsFor 0 ).to.eql []
    done()

  it 'untrack spy', ( done ) ->
    setBar = ->
    foo = { setBar }
    spy= jmspy.spyOn foo, 'setBar'
    jmspy.spyOff foo, 'setBar'
    expect( foo.setBar ).to.be setBar
    done()
