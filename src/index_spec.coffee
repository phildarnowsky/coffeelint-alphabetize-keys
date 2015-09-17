AlphabetizeKeys = require './'
coffeelint = require 'coffeelint'

alphabetical =
  defineClass: '''
    class A
      @variableA: 1 * 2
      @variableB: 'abc'
      @variableC: fn()

      @methodA: ->
      @methodB: ->
      @methodC: ->

      variableA: 1 * 2
      variableB: 'abc'
      variableC: fn()

      constructor: ->

      aMethod: ->
      methodA: ->
      methodB: ->
      methodC: ->

      _methodA: ->
      _methodB: ->
      _methodC: ->

      _variableA: 1 * 2
      _variableB: 'abc'
      _variableC: fn()
    '''
  defineObject: '''
    object =
      keyA: 1
      keyB: 2
      keyC: 3
    '''
  defineObjectWithNestedObject: '''
    object =
      keyA:
        keyD: 4
        keyE: 5
        keyF: 6
      keyB: 2
      keyC: 3
    '''
  defineObjectWithQuotedKeys: '''
    object =
      keyA: 1
      'keyB': 2
      "keyC": 3
    '''
  destructObjectArgument: 'fn = ({keyA, keyB, keyC}) ->'
  destructObjectAssignment: '{keyA, keyB, keyC} = object'
  destructObjectAssignmentWithThis: '{keyA, @keyB, keyC} = object'


notAlphabetical =
  defineClassWithInstanceMethods: '''
    class A
      methodC: ->
      methodB: ->
      methodA: ->
    '''
  defineClassWithInstanceVariables: '''
    class A
      variableC: fn()
      variableB: 'abc'
      variableA: 1 * 2
    '''
  defineClassWithPrivateMethods: '''
    class A
      _methodC: ->
      _methodB: ->
      _methodA: ->
    '''
  defineClassWithPrivateVariables: '''
    class A
      _variableC: fn()
      _variableB: 'abc'
      _variableA: 1 * 2
    '''
  defineClassWithStaticMethods: '''
    class A
      @methodC: ->
      @methodB: ->
      @methodA: ->
    '''
  defineClassWithStaticVariables: '''
    class A
      @variableC: fn()
      @variableB: 'abc'
      @variableA: 1 * 2
    '''
  defineObject: '''
    object =
      keyC: 3
      keyB: 2
      keyA: 1
    '''
  defineObjectWithNestedObject: '''
    object =
      keyA:
        keyF: 6
        keyE: 5
        keyD: 4
      keyB: 2
      keyC: 3
    '''
  defineObjectWithQuotedKeys: '''
    object =
      "keyC": 3
      'keyB': 2
      keyA: 1
    '''
  destructObjectArgument: 'fn = ({keyC, keyB, keyA}) ->'
  destructObjectAssignment: '{keyC, keyB, keyA} = object'
  destructObjectAssignmentWithThis: '{keyC, @keyB, keyA} = object'


describe 'alphabetize_keys', ->
  before ->
    coffeelint.registerRule AlphabetizeKeys

  context 'keys are alphabetical', ->
    Object.keys(alphabetical).forEach (name) ->
      context name, ->
        it 'returns no errors', ->
          errors = coffeelint.lint alphabetical[name]
          expect(errors).to.be.empty

  context 'keys are not alphabetical', ->
    Object.keys(notAlphabetical).forEach (name) ->
      context name, ->
        it 'returns no errors', ->
          errors = coffeelint.lint notAlphabetical[name]
          expect(errors).to.have.lengthOf 1
          expect(errors[0].rule).to.eql 'alphabetize_keys'
