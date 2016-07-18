class AlphaNode
  # This is a presenter class, but note that we don't have the usual delegation
  # to the presented object on unhandled messages that you get in most
  # presenters. In this case, the underlying AST API is so low level that we
  # would almost always want to write helper methods anyway, so there's no
  # reason to have the extra overhead to expose that API.

  constructor: (@presented, @astApi) ->

  methodName: () ->
    @__methodName ?= if @_isStatic()
                       @presented.variable.properties[0].name.value
                     else
                       @presented.variable.base.value

  _calledMethod: () ->
    @presented.value.variable &&
    @presented.value.variable.properties[0].name.value

  _dataType: () ->
    @__dataType ?= @astApi.getNodeName(@presented.value)

  _isConstant: () ->
    nodeName = @_dataType()
    calledMethod = @_calledMethod(@presented)

    nodeName is 'Value' && !(@_isTemplateLiteral()) ||
    nodeName is 'Op' ||
    calledMethod && calledMethod isnt 'template'

  _isMainTemplate: () ->
    @_isTemplate() && @presented.variable.base.value is 'template'

  _isMethod: () ->
    @_dataType() is 'Code'

  _isPublicMethod: () ->
    @_isMethod() && @methodName()[0] isnt '_'

  _isPrivateMethod: () ->
    @_isMethod() && @methodName()[0] is '_'

  _isStatic: () ->
    @presented.variable.base.value is 'this'

  _isTemplate: () ->
    @_isTemplateLiteral() || @_isTemplateCall()

  _isTemplateCall: () ->
    @presented.value.variable &&
    @presented.value.variable.base.value is '_' &&
    @_calledMethod(@presented) is 'template'

  _isTemplateLiteral: () ->
    # Even though a string literal is arguably not a template in the technical
    # sense, practically speaking we want to be able to use string literals as
    # templates without the overhead of a _.template call, so if a property is
    # a Value whose name ends in "template" (case-insensitive), we assume it's
    # a string meant to be used as a template.
    #
    @_isValue() && @methodName().match(/template$/i)

  _isValue: () ->
    @_dataType() is 'Value'

  _isSecondaryTemplate: () ->
    @_isTemplate() && @presented.variable.base.value isnt 'template'

  _isSetupMethod: () ->
    @_isMethod() &&
    (@methodName() is 'constructor' || @methodName() is 'initialize')

module.exports = AlphaNode
