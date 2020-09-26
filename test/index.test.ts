import * as parser from '../leglang'
parser;// To avoid rollup's tree shaking
let readFileSync = require('fs').readFileSync

test('Parsing sample', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/ship.leg').toString());
  expect(parsed.problem).toBe("Our ship frequency is not sufficient!");
  expect(parsed.solutions[0].solutionName).toBe("Law of compensating a shipping company");
  expect(parsed.solutions[1].solutionName).toBe("Law of encouraging shipping industry with the free market");
});