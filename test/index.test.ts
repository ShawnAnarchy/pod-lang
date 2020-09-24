import * as parser from '../leglang'
parser;// To avoid rollup's tree shaking


test('Parsing sample', () => {
  const parsed = global.parser.parse(`
problem: Our ship frequency is not sufficient!

solutions:
  - Pay $10000 per month for the shipping company.
  - Build a new ship with $200 and hire a $2000 per month sailor.
  - Do nothing.
  `);
  expect(parsed.problem).toBe("Our ship frequency is not sufficient!");
  expect(parsed.solutions[0]).toBe("Pay $10000 per month for the shipping company.");
  expect(parsed.solutions[1]).toBe("Build a new ship with $200 and hire a $2000 per month sailor.");
  expect(parsed.solutions[2]).toBe("Do nothing.");

});