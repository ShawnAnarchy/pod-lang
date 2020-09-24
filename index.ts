import * as parser from './leglang'
parser;// To avoid rollup's tree shaking

try {
    const sampleOutput = global.parser.parse('problem:test');
    console.log(sampleOutput)
}
catch (ex)
{
  console.error(ex)
  // Handle parsing error
    // [...]
}