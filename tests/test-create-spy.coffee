
# /*
#   Spies
#   When there is not a function to spy on, 
#   jasmine.createSpy can create a “bare” spy. 
#   This spy acts as any other spy – tracking calls, arguments, etc. 
#   But there is no implementation behind it. 
#   Spies are JavaScript objects and can be used as such.   
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 15:57:05 GMT+0800 (CST)
# */
#

"use strict"

expect = require 'expect.js'
jmspy  = require '../index.js'

describe "A spy, when created manually", ->
  whatAmI = null

  beforeEach ->
    whatAmI = jmspy.createSpy 'whatAmI'

    whatAmI "I", "am", "a", "spy"

  it "is named, which helps in error reporting", ( done ) ->
    expect( whatAmI.and.identity() ).to.eql 'whatAmI'
    done()

  it "tracks that the spy was called", ( done ) ->
    expect( whatAmI.calls.any() ).to.be.ok()
    done()

  it "tracks its number of calls", ( done ) ->
    expect( whatAmI.calls.count() ).to.eql 1
    done()

  it "tracks all the arguments of its calls", ( done ) ->
    expect( whatAmI.calls.allArgs() ).to.eql [ [ "I", "am", "a", "spy" ] ]
    done()

  it "allows access to the most recent call", ( done ) ->
    expect( whatAmI.calls.mostRecent().args[ 0 ] ).to.eql "I"
    done()

  it 'create spy with original fn', ( done ) ->
    amspy = jmspy.createSpy 'amspy', testMethod : 'test method'
    expect( amspy.testMethod ).to.be 'test method'
    done()

  it 'create spy with origin fn which was an another spy', ( done ) ->
    try
      amspy  = jmspy.createSpy 'amspy'
      amspy2 = jmspy.createSpy 'amspy2', amspy
    catch e
      expect( e.message ).to.be 'Jasmine spies would overwrite the \'and\' and \'calls\' properties on the object being spied upon'
      done()    
