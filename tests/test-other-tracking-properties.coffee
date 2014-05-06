
# /*
#   Other tracking properties
#   Every call to a spy is tracked and exposed on the calls property.
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
      setBar : ( value ) ->
        bar = value
    spy = jmspy.spyOn foo, 'setBar'

  # .calls.any(): returns false if the spy has not been called at all, and then true once at least one call happens.
  it "tracks if it was called at all", ( done ) ->
    expect( foo.setBar.calls.any() ).to.be false

    foo.setBar()

    expect( foo.setBar.calls.any() ).to.be true
    done()

  # .calls.count(): returns the number of times the spy was called
  it "tracks the number of times it was called", ( done ) ->
    expect( foo.setBar.calls.count() ).to.be 0

    foo.setBar()
    foo.setBar()

    expect( foo.setBar.calls.count() ).to.be 2
    done()

  # .calls.argsFor(index): returns the arguments passed to call number index
  it "tracks the arguments of each call", ( done ) ->
    foo.setBar 123
    foo.setBar 456, "baz"

    expect( foo.setBar.calls.argsFor( 0 ) ).to.eql [ 123 ]
    expect( foo.setBar.calls.argsFor(1) ).to.eql [ 456, "baz" ]
    done()

  # .calls.allArgs(): returns the arguments to all calls
  it "tracks the arguments of all calls", ( done ) ->
    foo.setBar 123
    foo.setBar 456, "baz"

    expect( foo.setBar.calls.allArgs() ).to.eql [ [ 123 ],[ 456, "baz" ] ]
    done()

  # .calls.all(): returns the context (the this) and arguments passed all calls
  it "can provide the context and arguments to all calls", ( done ) ->
    foo.setBar 123

    expect( foo.setBar.calls.all() ).to.eql [ { object: foo, args: [ 123 ] } ]
    done()

  # .calls.mostRecent(): returns the context (the this) and arguments for the most recent call
  it "has a shortcut to the most recent call", ( done ) ->
    foo.setBar 123
    foo.setBar 456, "baz"

    expect( foo.setBar.calls.mostRecent() ).to.eql { object: foo, args: [ 456, "baz" ] }
    done()

  # .calls.first(): returns the context (the this) and arguments for the first call
  it "has a shortcut to the first call", ( done ) ->
    foo.setBar 123
    foo.setBar 456, "baz"

    expect( foo.setBar.calls.first() ).to.eql { object: foo, args: [ 123 ] }
    done()

  # .calls.reset(): clears all tracking for a spy
  it "can be reset", ( done ) ->
    foo.setBar 123
    foo.setBar 456, "baz"

    expect( foo.setBar.calls.any() ).to.be true

    foo.setBar.calls.reset()

    expect( foo.setBar.calls.any() ).to.be false
    done()
