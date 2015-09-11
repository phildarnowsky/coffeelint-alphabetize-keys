AlphabetizeKeys = require './'
coffeelint = require 'coffeelint'

alphabetical =
  defineClass: '''
    class A
      keyA: 1
      keyB: 2
      keyC: 3
    '''
  defineClassWithConstructor: '''
    class A
      keyA: 1
      constructor: 0
      keyB: 2
      keyC: 3
    '''
  defineClassWithClassMethods: '''
    class A
      @keyD: 1
      @keyE: 2
      @keyF: 3
      keyA: 4
      keyB: 5
      keyC: 6
    '''
  defineClassWithInteralExpressions: '''
    class A
      A = 1
      keyA: 1
      keyB: 2
      keyC: 3
    '''
  defineClassWithPrivateMethod: '''
    class A
      keyD: 1
      keyE: 2
      keyF: 3
      _keyA: 4
      _keyB: 5
      _keyC: 6
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
  destructObjectArgument: 'fn = ({keyA, keyB, keyC}) ->'
  destructObjectAssignment: '{keyA, keyB, keyC} = object'
  destructObjectAssignmentWithThis: '{keyA, @keyB, keyC} = object'


notAlphabetical =
  defineClass: '''
    class A
      keyC: 3
      keyB: 2
      keyA: 1
    '''
  defineClassWithClassMethods: '''
    class A
      @keyF: 3
      @keyE: 2
      @keyD: 1
      keyA: 4
      keyB: 5
      keyC: 6
    '''
  defineClassWithPrivateMethod: '''
    class A
      keyD: 1
      keyE: 2
      keyF: 3
      _keyC: 6
      _keyB: 5
      _keyA: 4
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
