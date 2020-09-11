import * as parser from './arithmetics'

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