
# /*
#   CallTracker
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 17:31:41 GMT+0800 (CST)
# */
#

"use strict"

class SpyStrategy

  plan : () ->

  constructor : ( options ) ->
    @_identity  = options.name   or 'unknown'
    @originalFn = options.fn     or () ->
    @getSpy     = options.getSpy

  identity : ->
    @_identity

  exec : ( args... ) ->
    @plan.apply @, args

  callThrough : () ->
    @plan = @originalFn
    @getSpy()

  returnValue : ( value ) ->
    @plan = () -> value
    @getSpy()

  throwError : ( something ) ->
    error = if something instanceof Error then something else new Error something
    @plan = () -> throw error
    @getSpy()

  callFake : ( fn ) ->
    @plan = fn
    @getSpy()

  stub : ( fn ) ->
    @plan = () ->
    @getSpy()

exports = module.exports = SpyStrategy