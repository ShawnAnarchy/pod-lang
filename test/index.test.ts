import * as parser from '../leglang'
parser;// To avoid rollup's tree shaking


test('Parsing sample', () => {
  const parsed = global.parser.parse('problem: Our ship frequency is not sufficient!');
  expect(parsed.problem).toBe("Our ship frequency is not sufficient!");
});