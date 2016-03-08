AlphabetizeKeys = require './'
coffeelint = require 'coffeelint'


alphabetical =
  'define class': '''
    class A
      @variableA: 1 * 2
      @variableB: 'abc'
      @variableC: fn()

      @_variableA: 1 * 2
      @_variableB: 'abc'
      @_variableC: fn()

      @methodA: ->
      @methodB: ->
      @methodC: ->

      @_methodA: ->
      @_methodB: ->
      @_methodC: ->

      variableA: 1 * 2
      variableB: 'abc'
      variableC: fn()

      _variableA: 1 * 2
      _variableB: 'abc'
      _variableC: fn()

      constructor: ->

      aMethod: ->
      methodA: ->
      methodB: ->
      methodC: ->

      _methodA: ->
      _methodB: ->
      _methodC: ->
    '''
  'define object': '''
    object =
      keyA: 1
      keyB: 2
      keyC: 3
    '''
  # coffeelint: disable=no_interpolation_in_single_quotes
  'define object with interpolated keys': '''
    object =
      keyA: 1
      "#{interpolated}": 2
      keyB: 3
    '''
  # coffeelint: enable=no_interpolation_in_single_quotes
  'define object with nested object': '''
    object =
      keyA:
        keyD: 4
        keyE: 5
        keyF: 6
      keyB: 2
      keyC: 3
    '''
  'define object with quoted keys': '''
    object =
      keyA: 1
      'keyB': 2
      "keyC": 3
    '''
  'destruct object argument': 'fn = ({keyA, keyB, keyC}) ->'
  'destruct object assignment': '{keyA, keyB, keyC} = object'
  'destruct object assignment with this': '{keyA, @keyB, keyC} = object'


notAlphabetical =
  'define class with private instance methods': '''
    class A
      _methodC: ->
      _methodB: ->
      _methodA: ->
    '''
  'define class with private instance variables': '''
    class A
      _variableC: fn()
      _variableB: 'abc'
      _variableA: 1 * 2
    '''
  'define class with private static methods': '''
    class A
      @_methodC: ->
      @_methodB: ->
      @_methodA: ->
    '''
  'define class with private static variables': '''
    class A
      @_variableC: fn()
      @_variableB: 'abc'
      @_variableA: 1 * 2
    '''
  'define class with public instance methods': '''
    class A
      methodC: ->
      methodB: ->
      methodA: ->
    '''
  'define class with public instance variables': '''
    class A
      variableC: fn()
      variableB: 'abc'
      variableA: 1 * 2
    '''
  'define class with public static methods': '''
    class A
      @methodC: ->
      @methodB: ->
      @methodA: ->
    '''
  'define class with public static variables': '''
    class A
      @variableC: fn()
      @variableB: 'abc'
      @variableA: 1 * 2
    '''
  'define object': '''
    object =
      keyC: 3
      keyB: 2
      keyA: 1
    '''
  'define object with nested object': '''
    object =
      keyA:
        keyF: 6
        keyE: 5
        keyD: 4
      keyB: 2
      keyC: 3
    '''
  'define object with quoted keys': '''
    object =
      "keyC": 3
      'keyB': 2
      keyA: 1
    '''
  'destruct object argument': 'fn = ({keyC, keyB, keyA}) ->'
  'destruct object assignment': '{keyC, keyB, keyA} = object'
  'destruct object assignment with this': '{keyC, @keyB, keyA} = object'


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
        it 'returns an error', ->
          errors = coffeelint.lint notAlphabetical[name]
          expect(errors).to.have.lengthOf 2
          expect(errors[0].rule).to.eql 'alphabetize_keys'

  context 'overrides', ->
    beforeEach ->
      @str = '''
        class A
          methodD: ->
          methodB: ->
          methodA: ->
          methodC: ->
        '''

    context 'matches overrides ordering', ->
      it 'returns no errors', ->
        opts = alphabetize_keys: overrides: ['methodD', 'methodB', 'methodA', 'methodC']
        errors = coffeelint.lint @str, opts
        expect(errors).to.be.empty

    context 'does not match overrides ordering', ->
      it 'returns an error', ->
        opts = alphabetize_keys: overrides: ['methodD', 'methodA', 'methodB', 'methodC']
        errors = coffeelint.lint @str, opts
        expect(errors).to.have.lengthOf 1
        expect(errors[0].rule).to.eql 'alphabetize_keys'

    context 'with other keys', ->
      it 'alphabetical', ->
        opts = alphabetize_keys: overrides: ['methodD', 'methodB']
        errors = coffeelint.lint @str, opts
        expect(errors).to.be.empty

      it 'not alphabetical', ->
        opts = alphabetize_keys: overrides: ['methodB', 'methodA']
        errors = coffeelint.lint @str, opts
        expect(errors).to.have.lengthOf 1
        expect(errors[0].rule).to.eql 'alphabetize_keys'
