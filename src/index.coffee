class AlphabetizeKeys

  lintAST: (node, astApi) ->
    @_lintNode node, astApi
    null


  rule:
    description: 'Makes finding keys within an object very easy'
    level: 'error'
    message: 'Object and class keys should be alphabetized'
    name: 'alphabetize_keys'


  _emptyClassKeyMapping: ->
    private:
      instance:
        method: []
        variable: []
      static:
        method: []
        variable: []
    public:
      instance:
        method: []
        variable: []
      static:
        method: []
        variable: []


  _getClassPropertyInfo: (property, astApi) ->
    keyNode = @_getPropertyValueNode property, astApi
    key = keyNode.base.value
    classType = 'instance'
    if key is 'this'
      key = keyNode.properties[0].name.value
      classType = 'static'
    visibility = if key[0] is '_' then 'private' else 'public'
    valueType = if astApi.getNodeName(property.value) is 'Code' then 'method' else 'variable'

    {classType, key, valueType, visibility}


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
    keysMapping = @_emptyClassKeyMapping()

    node.body.expressions.forEach (expression) =>
      return unless astApi.getNodeName(expression.base) is 'Obj'
      expression.base.properties.forEach (property) =>
        {classType, key, valueType, visibility} = @_getClassPropertyInfo property, astApi

        return if visibility is 'public' and
          classType is 'instance' and
          valueType is 'method' and
          key is 'constructor'

        keysMapping[visibility][classType][valueType].push key

    for visibility, visibilityMapping of keysMapping
      for classType, classTypeMapping of visibilityMapping
        for valueType, keys of classTypeMapping
          @_lintNodeKeys node, astApi, keys, [visibility, classType, valueType].join(' ')


  _lintNode: (node, astApi) ->
    switch astApi.getNodeName node
      when 'Class'
        @_lintClass node, astApi
      when 'Obj'
        @_lintObject node, astApi
      else
        node.eachChild (child) => @_lintNode child, astApi


  _lintNodeKeys: (node, astApi, keys, prefix) ->
    keys = keys.map @_stripQuotes
    for key, index in keys when index isnt 0 and keys[index - 1] > key
      @errors.push astApi.createError {
        lineNumber: node.locationData.first_line + 1
        message: "#{prefix} keys should be alphabetized: #{keys[index - 1]} appears before #{key}"
        rule: 'alphabetize_keys'
      }


  _lintObject: (node, astApi) ->
    keys = []

    node.properties.forEach (property) =>
      keyNode = @_getPropertyValueNode property, astApi
      return if keyNode.base.isComplex()
      key = keyNode.base.value
      key = keyNode.properties[0].name.value if key is 'this'
      keys.push key

    @_lintNodeKeys node, astApi, keys, 'Object'


  _stripQuotes: (key) ->
    if singleQuoteMatch = key.match(/^'(.*)'$/)
      singleQuoteMatch[1]
    else if doubleQuoteMatch = key.match(/^"(.*)"$/)
      doubleQuoteMatch[1]
    else
      key


module.exports = AlphabetizeKeys
