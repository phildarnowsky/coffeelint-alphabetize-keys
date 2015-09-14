# coffeelint-alphabetize-keys

[![NPM Version](https://img.shields.io/npm/v/coffeelint-alphabetize-keys.svg)](https://www.npmjs.com/package/coffeelint-alphabetize-keys)
[![Build Status](https://img.shields.io/circleci/project/charlierudolph/coffeelint-alphabetize-keys/master.svg)](https://circleci.com/gh/charlierudolph/coffeelint-alphabetize-keys/tree/master)

Coffeelint rule requiring objects to have keys in alphabetical order

## Installation

```
npm install coffeelint-alphabetize-keys
```

## Usage

Put this in your coffeelint config:

```json
"alphabetize_keys": {
  "module": "coffeelint-alphabetize-keys",
}
```

## Examples

### Objects

```coffee
{keyA, keyB, keyC} # Good
{keyC, keyB, keyA} # Bad
```

The rule applies to both defining and destructing objects.

### Classes

The rule differentiates between variables and methods,
and each are required to only be individually alphabetical.

```coffee
# Good
class A
  variableA: 1 * 2
  variableB: 'abc'
  variableC: fn()

  methodA: ->
  methodB: ->
  methodC: ->

# Bad
class A
  variableC: fn()
  variableB: 'abc'
  variableA: 1 * 2

  methodC: ->
  methodB: ->
  methodA: ->
```

Methods and variables are also broken down into static, instance, and private instance (starting with `_`)
where each are required to only be individually alphabetical.
