module.exports = class AlphabetizeKeys

  rule:
    name: 'alphabetize_keys'
    level: 'error'
    message: 'Object keys should be alphabetized'
    description: 'Makes finding keys within an object very easy'


  tokens: [ 'CLASS', 'INDENT', 'OUTDENT', 'IDENTIFIER', '{', '}' ]


  constructor: ->
    @scopes = []
    @currentScope = null


  lintBrace: (token, tokenApi) ->
    error = false

    if token[0] is '{'
      @scopes.push @currentScope if @currentScope?
      @currentScope = []
    else
      for key, index in @currentScope when index isnt 0
        if key < @currentScope[index - 1]
          error = true
          break
      @currentScope = @scopes.pop()

    error


  lintIdentifier: (token, tokenApi) ->
    @currentScope?.push token[1]
    null


  lintToken: (token, tokenApi) ->
    switch token[0]
      when '{', '}'
        @lintBrace arguments...
      when 'IDENTIFIER'
        @lintIdentifier arguments...
