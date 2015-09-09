AlphabetizeKeys = require './'
coffeelint = require 'coffeelint'

alphabetical =
  defineObject: '''
    object =
      keyA: 1
      keyB: 2
      keyC: 3
    '''
  defineNestedObject: '''
    object =
      keyA:
        keyD: 4
        keyE: 5
        keyF: 6
      keyB: 2
      keyC: 3
    '''
  destructObjectAssignment: '{keyA, keyB, keyC} = object'
  destructObjectAssignmentWithThis: '{keyA, @keyB, keyC} = object'
  destructObjectArgument: 'fn = ({keyA, keyB, keyC}) ->'


notAlphabetical =
  defineObject: '''
    object =
      keyC: 3
      keyB: 2
      keyA: 1
    '''
  defineNestedObject: '''
    object =
      keyA:
        keyF: 6
        keyE: 5
        keyD: 4
      keyB: 2
      keyC: 3
    '''
  destructObjectAssignment: '{keyC, keyB, keyA} = object'
  destructObjectArgument: 'fn = ({keyC, keyB, keyA}) ->'


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
