# coffeelint-alphabetize-keys

[![NPM Version](https://img.shields.io/npm/v/coffeelint-alphabetize-keys.svg)](https://www.npmjs.com/package/coffeelint-alphabetize-keys)
[![Build Status](https://img.shields.io/circleci/project/charlierudolph/coffeelint-alphabetize-keys/master.svg)](https://circleci.com/gh/charlierudolph/coffeelint-alphabetize-keys/tree/master)

Coffeelint rule requiring objects to have keys in alphabetical order

## Examples
```coffee
{keyA, keyB, keyC} # Good
{keyC, keyB, keyA} # Bad
```

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
