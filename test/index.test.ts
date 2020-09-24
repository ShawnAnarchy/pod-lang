import * as parser from '../leglang'
parser;// To avoid rollup's tree shaking


test('Parsing sample', () => {
  const parsed = global.parser.parse('1+1');
  expect(parsed).toBe(2);
});