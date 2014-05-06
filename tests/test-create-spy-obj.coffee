
# /*
#   Spies: createSpyObj
#   In order to create a mock with multiple spies, 
#   use jasmine.createSpyObj and pass an array of strings. 
#   It returns an object that has a property for each string that is a spy.
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 15:57:05 GMT+0800 (CST)
# */
#

"use strict"

expect = require 'expect.js'
jmspy  = require '../index.js'

describe "Multiple spies, when created manually", ->
  tape = null

  beforeEach ->
    tape = jmspy.createSpyObj 'tape', [ 'play', 'pause', 'stop', 'rewind' ]

    tape.play()
    tape.pause()
    tape.rewind 0

  it "creates spies for each requested function", ( done ) ->
    expect( undefined != tape.play   ).to.be.ok()
    expect( undefined != tape.pause  ).to.be.ok()
    expect( undefined != tape.stop   ).to.be.ok()
    expect( undefined != tape.rewind ).to.be.ok()
    done()

  it "tracks that the spies were called", ( done ) ->
    expect( tape.play.calls.any()   ).to.be.ok()
    expect( tape.pause.calls.any()  ).to.be.ok()
    expect( tape.rewind.calls.any() ).to.be.ok()
    expect( tape.stop.calls.any()   ).not.to.be.ok()
    done()

  it "tracks all the arguments of its calls", ( done ) ->
    expect( tape.rewind.calls.allArgs() ).to.eql [ [ 0 ] ]
    done()

  it 'create spy obj with undefined methods', ( done ) ->
    try
      jmspy.createSpyObj 'amspy'
    catch e
      expect( e.message ).to.be 'createSpyObj requires a non-empty array of method names to create spies for'
      done()

  it 'create spy obj with empty array', ( done ) ->
    try
      jmspy.createSpyObj 'amspy', []
    catch e
      expect( e.message ).to.be 'createSpyObj requires a non-empty array of method names to create spies for'
      done()