import * as parser from './arithmetics'
parser;// To avoid rollup's tree shaking

try {
    const sampleOutput = global.parser.parse('1+1');
    console.log(sampleOutput)
}
catch (ex)
{
  console.error(ex)
  // Handle parsing error
    // [...]
}