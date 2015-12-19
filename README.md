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
  "module": "coffeelint-alphabetize-keys"
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

```coffee
# Good
class A
  methodA: ->
  methodB: ->
  methodC: ->

# Bad
class A
  methodC: ->
  methodB: ->
  methodA: ->
```

The keys are broken down into 8 categories and
each are required to only be individually alphabetical.
Keys are seperated based on:
* function vs variable (based on the type of the value)
* public vs private (key starting with `_` is private)
* instance vs static

The `constructor` function is ignored.
