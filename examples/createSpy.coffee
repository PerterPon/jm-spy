expect = require 'expect.js'
jmspy = require 'jm-spy'

Person = {}

Message = 
  sayHello: (id) ->
    Person.getName id, (err, name) ->
      if err
        return console.log err
      console.log "hello #{name}!"

describe 'Message sayHello', () ->

  spy = null
  before () ->
    spy = jmspy.createSpy 'getName'
    Person.getName = spy
  
  it 'success', () ->
    spy.and.callFake (id, cb) ->
      expect(id).to.be 1
      cb null, 'rose'
    Message.sayHello 1

  it 'fail', () ->
    spy.and.callFake (id, cb) ->
      expect(id).to.be null
      cb new Error 'id is null'
    Message.sayHello null
