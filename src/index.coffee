class AlphabetizeKeys
  AlphaNode = require('./alphanode')

  # Coffeelint's main entry point
  lintAST: (node, astApi) ->
    @_lintNode node, astApi
    null

  # Coffeelint also requires this to be set, with these fields
  rule:
    description: 'Makes finding keys within an object very easy'
    level: 'error'
    message: 'Object and class keys should be alphabetized'
    name: 'alphabetize_keys'
    overrides: []

  _classSectionIndex: (sectionName) ->
    @_classSectionNames().indexOf(sectionName)

  _classSectionNames: () ->
    @__sectionNames ?= (pair[0] for pair in @_classSectionTests)

  # Class properties should be in this order:
  #   Constants
  #   Static methods
  #   Template methods (if applicable), with the main template first
  #   Constructor/initialize method
  #   Public methods
  #   Private methods (whose names should begin with the "_" character)

  _classSectionTests:
    [
      ['constant', '_isConstant'],
      ['static', '_isStatic'],
      ['mainTemplate', '_isMainTemplate'],
      ['secondaryTemplate', '_isSecondaryTemplate'],
      ['setupMethod', '_isSetupMethod'],
      ['publicMethod', '_isPublicMethod'],
      ['privateMethod', '_isPrivateMethod']
    ]

  _lintClass: (node, astApi) ->
    lastSection = null
    lastIndex = null
    lastName = null

    node.body.expressions.forEach (expression) =>
      return unless astApi.getNodeName(expression.base) is 'Obj'
      expression.base.properties.forEach (presented) =>
        property = new AlphaNode(presented, astApi)
        name = property.methodName()
        section = @_nodeSection property
        index = @_classSectionIndex section
        if lastName && ([lastIndex, lastName] > [index, name])
          @errors.push astApi.createError {
            lineNumber: node.locationData.first_line + 1
            message: "Class keys should be alphabetized: " +
                     "#{lastSection} #{lastName} comes before " +
                     "#{section} #{name}"
            rule: 'alphabetize_keys'
          }
        lastSection = section
        lastIndex = index
        lastName = name

  _lintNode: (node, astApi) ->
    if astApi.getNodeName(node) is 'Class'
      @_lintClass node, astApi
    else
      node.eachChild (child) => @_lintNode child, astApi

  _nodeSection: (property, astApi) ->
    foundSection = null
    @_classSectionTests.forEach ([sectionName, predicateName]) =>
        foundSection ?= (sectionName if property[predicateName]())
    foundSection or throw("Couldn't determine proper section for " + property)

module.exports = AlphabetizeKeys
