
# /*
#   CallTracker
#   Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
#   Create: Sat Apr 19 2014 17:31:41 GMT+0800 (CST)
# */
#

"use strict"

CallTracker = require './call-tracker'
SpyStrategy = require './spy-strategy'

spies = []

isSpy = ( putativeSpy ) ->
  return false if not putativeSpy
  return ( putativeSpy.and instanceof SpyStrategy ) and 
    ( putativeSpy.calls instanceof CallTracker )

spyOn = ( obj, methodName ) ->
  if obj is undefined
    throw new Error "spyOn could not find an object to spy upon for #{methodName}()"
  if obj[ methodName ] is undefined
    throw new Error "#{methodName}() method does not exist"
  if obj[ methodName ] and isSpy obj[ methodName ]
    throw new Error "#{methodName} has already been spied upon"

  _originMethod = obj[ methodName ]

  spy = createSpy methodName, obj[ methodName ]

  idx = spies.push
    spy : spy
    baseObj : obj
    methodName : methodName
    originalValue : obj[ methodName ]

  spy._originMethod = _originMethod
  spy._spyIdx = idx
  obj[ methodName ] = spy

  return spy

spyOff = ( obj, methodName ) ->
  if obj is undefined
    throw new Error "spyOff could not find an object to spy upoff for #{methodName}()"
  if obj[ methodName ] is undefined
    throw new Error "#{methodName}() method does not exist"
  if obj[ methodName ] and not isSpy obj[ methodName ]
    throw new Error "#{methodName} was not been spy on"
  spy = obj[ methodName ]
  { _originMethod, _spyIdx }   = spy
  obj[ methodName ] = _originMethod
  spies[ _spyIdx..._spyIdx+1 ] = []
  _originMethod

createSpy = ( name, originalFn ) ->
  callTracker = new CallTracker()
  spy = () ->
    callTracker.track
      object : @
      args   : Array.prototype.slice.apply arguments
    return spyStrategy.exec.apply spyStrategy, arguments
  spyStrategy = new SpyStrategy
    name   : name
    fn     : originalFn
    getSpy : () -> spy
  for prop of originalFn
    if prop is 'and' or prop is 'calls'
      throw Error 'Jasmine spies would overwrite the \'and\' and \'calls\' properties on the object being spied upon'

    spy[ prop ] = originalFn[ prop ]

  spy.and   = spyStrategy
  spy.calls = callTracker
  spy

createSpyObj = ( baseName, methodNames ) ->
  if ( not Array.isArray methodNames ) or ( methodNames.length is 0 )
    throw new Error 'createSpyObj requires a non-empty array of method names to create spies for'
  obj = {}
  for method in methodNames
    obj[ method ] = createSpy "#{baseName}.#{method}"
  obj

module.exports = 
  spyOn  : spyOn
  isSpy  : isSpy
  spyOff : spyOff
  createSpy : createSpy
  createSpyObj : createSpyObj
