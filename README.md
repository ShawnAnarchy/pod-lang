# leglang
A language for proposing an administration and a law

## Purpose
- To generate legal sentenses from cson files
- To make a tx that generates administrations from cson file
- To make a tx that top-up budget for administrations from cson file

## Law dir
- pseudo store of approved laws


## Proposals dir
- language examples for language design iteration

### Challenges
- It has to be easy to read for non-legal people
- It has to be easy to write for legal people
- It has to be explicit about what it means
- It has to be composable to call other law or administration
- It has to generate administrations with `<law name>.pod` file
- It has to allocate budget to administrations with `prop.pod` file 
- It has to be able to refer existing law of other nation with static manner
  - The refering document can be a podlang file or a pdf file which is converted from arbitrary digital data format.

## Dev Tips
- `node parserGenerator.js` outputs parser file
- `rollup -c && node index.js` for dev iteration
- `NODE_ENV=test rollup -c && jest ./test/index.test.js` for running test