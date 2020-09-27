import * as parser from '../leglang'
parser;// To avoid rollup's tree shaking
let readFileSync = require('fs').readFileSync

describe('Ship Management', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/ship.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("Our ship frequency is not sufficient!");
  });

  it('has some solution names', () => {
    expect(parsed.solutions[0].solutionName).toBe("Law of encouraging shipping industry with a new administration new by using the free market");
    expect(parsed.solutions[1].solutionName).toBe("Law of encouraging shipping industry with a existing administration new by using the free market");
    expect(parsed.solutions[2].solutionName).toBe("Law of compensating a shipping company");
  });
  it('has a soluton creating a new subset, setting a vesting config for that, and defining some laws', () => {
    expect(parsed.solutions[0].headerObj.new).toBe("Ship Management Administration");
    expect(parsed.solutions[0].headerObj.assign).toBe("");
    expect(parsed.solutions[0].headerObj.vestings.length).toBe(1);
    expect(parsed.solutions[0].headerObj.vestings[0].to).toBe("NEW_SUBSET");
    expect(parsed.solutions[0].headerObj.vestings[0].budget).toBe(2000);
    expect(parsed.solutions[0].lawObj[0][0]).toBe("Permission of a individual shipping business");
    expect(parsed.solutions[0].lawObj[0][1][0]).toBe("Anyone can let customers move other islands by charging arbitrary fee.");
  });
  it('has a solution which assigns existing administration', () => {
    expect(parsed.solutions[1].headerObj.assign).toBe("shipAdmin.aogashima.onthe.eth");
  });
  it("has a solution which doesn't make any administration and just pass vesting to addresses", () => {
    expect(parsed.solutions[2].headerObj.new).toBe("");
    expect(parsed.solutions[2].headerObj.assign).toBe("");
    expect(parsed.solutions[2].headerObj.vestings[0].to).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[2].headerObj.vestings[1].to).toBe("0xee0B645Bb006d9bcE9227Ba53E31D117D533eF5c");
    expect(parsed.solutions[2].headerObj.vestings[0].budget).toBe(10000);
    expect(parsed.solutions[2].headerObj.vestings[1].budget).toBe(200);
    expect(!!parsed.solutions[2].lawObj).toBe(false);
  });
});