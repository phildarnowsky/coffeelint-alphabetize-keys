class AlphabetizeKeys

  lintAST: (node, astApi) ->
    @_lintNode node, astApi
    null


  rule:
    description: 'Makes finding keys within an object very easy'
    level: 'error'
    message: 'Object keys should be alphabetized'
    name: 'alphabetize_keys'


  _getPropertyValueNode: (property, astApi) ->
    if astApi.getNodeName(property) is 'Value'
      property
    else if astApi.getNodeName(property.variable) is 'Value'
      @_lintNode property.value, astApi
      property.variable
    else
      throw Error """
        Cannot handle property
        #{property}
        """


  _lintClass: (node, astApi) ->
    keysMapping = {
      instanceMethods: []
      instanceVariables: []
      privateMethods: []
      privateVariables: []
      staticMethods: []
      staticVariables: []
    }

    node.body.expressions.forEach (expression) =>
      return unless astApi.getNodeName(expression.base) is 'Obj'
      expression.base.properties.forEach (property) =>
        keyNode = @_getPropertyValueNode property, astApi
        key = keyNode.base.value
        if astApi.getNodeName(property.value) is 'Code'
          if key is 'this'
            keysMapping.staticMethods.push keyNode.properties[0].name.value
          else if key[0] is '_'
            keysMapping.privateMethods.push key
          else if key isnt 'constructor'
            keysMapping.instanceMethods.push key
        else
          if key is 'this'
            keysMapping.staticVariables.push keyNode.properties[0].name.value
          else if key[0] is '_'
            keysMapping.privateVariables.push key
          else
            keysMapping.instanceVariables.push key

    for id, keys of keysMapping
      @_lintNodeKeys node, astApi, keys


  _lintNode: (node, astApi) ->
    switch astApi.getNodeName node
      when 'Class'
        @_lintClass node, astApi
      when 'Obj'
        @_lintObject node, astApi
      else
        node.eachChild (child) => @_lintNode child, astApi


  _lintNodeKeys: (node, astApi, keys) ->
    keys = keys.map @_stripQuotes
    for key, index in keys when index isnt 0 and keys[index - 1] > key
      @errors.push astApi.createError {
        lineNumber: node.locationData.first_line + 1
        rule: 'alphabetize_keys'
      }
      return


  _lintObject: (node, astApi) ->
    keys = []

    node.properties.forEach (property) =>
      keyNode = @_getPropertyValueNode property, astApi
      return if keyNode.base.isComplex()
      key = keyNode.base.value
      key = keyNode.properties[0].name.value if key is 'this'
      keys.push key

    @_lintNodeKeys node, astApi, keys


  _stripQuotes: (key) ->
    if singleQuoteMatch = key.match(/^'(.*)'$/)
      singleQuoteMatch[1]
    else if doubleQuoteMatch = key.match(/^"(.*)"$/)
      doubleQuoteMatch[2]
    else
      key


module.exports = AlphabetizeKeys
