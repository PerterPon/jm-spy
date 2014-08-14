expect = require 'expect.js'
jmspy = require 'jm-spy'

Person = {}

Message = 
  sayHello: (id) ->
    Person.getName id, (err, name) ->
      if err
        return console.log err
      console.log "hello #{name}!"

  sayAge: (id) ->
    Person.getAge id, (err, age) ->
      if err
        return console.log err
      console.log "my age is #{age}"

describe 'Message', () ->

  spy1 = null
  spy2 = null
  before () ->
    Person = jmspy.createSpyObj 'Person', ['getName', 'getAge']
    spy1 = Person.getName
    spy2 = Person.getAge
  
  it 'sayHello success', () ->
    spy1.and.callFake (id, cb) ->
      expect(id).to.be 1
      cb null, 'rose'
    Message.sayHello 1

  it 'sayHello fail', () ->
    spy1.and.callFake (id, cb) ->
      expect(id).to.be null
      cb new Error 'sayHello id is null'
    Message.sayHello null

  it 'sayAge success', () ->
    spy2.and.callFake (id, cb) ->
      expect(id).to.be 1
      cb null, 18
    Message.sayAge 1

  it 'sayAge fail', () ->
    spy2.and.callFake (id, cb) ->
      expect(id).to.be null
      cb new Error 'sayAge id is null'
    Message.sayAge null
