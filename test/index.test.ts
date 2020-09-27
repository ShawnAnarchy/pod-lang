import * as parser from '../leglang'
parser;// To avoid rollup's tree shaking
let readFileSync = require('fs').readFileSync

describe('Problem Decalaration of Ship Management', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/sma_only_problem.leg').toString());
  it('has a problem', () => {
    expect(parsed.problem).toBe("Our ship frequency is not sufficient!");
  });
})

describe('Creation of Ship Management', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/sma_creation.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("Our ship frequency is not sufficient!");
  });

  it('has some solution names', () => {
    expect(parsed.solutions[0].solutionName).toBe("Law of encouraging shipping industry with a new administration new by using the free market");
    expect(parsed.solutions[1].solutionName).toBe("Law of encouraging shipping industry with a existing administration new by using the free market");
    expect(parsed.solutions[2].solutionName).toBe("Law of compensating a shipping company");
  });
  it('has a soluton creating a new subset, setting a vesting config for that, and defining some laws', () => {
    expect(parsed.solutions[0].commandObj.new).toBe("Ship Management Administration");
    expect(parsed.solutions[0].commandObj.assign).toBe("");
    expect(parsed.solutions[0].commandObj.vestings.length).toBe(1);
    expect(parsed.solutions[0].commandObj.vestings[0].to).toBe("NEW_SUBSET");
    expect(parsed.solutions[0].commandObj.vestings[0].vesting).toBe(2000);
    expect(parsed.solutions[0].lawObj.id).toBe("LAW_ID_NEW");
    expect(parsed.solutions[0].lawObj.lawName).toBe("Permission of a individual shipping business");
    expect(parsed.solutions[0].lawObj.laws[0]).toBe("Anyone can let customers move other islands by charging arbitrary fee.");
  });
  it('has a solution which assigns existing administration', () => {
    expect(parsed.solutions[1].commandObj.assign).toBe("shipAdmin.aogashima.onthe.eth");
  });
  it("has a solution which doesn't make any administration and just pass vesting to addresses", () => {
    expect(parsed.solutions[2].commandObj.new).toBe("");
    expect(parsed.solutions[2].commandObj.assign).toBe("");
    expect(parsed.solutions[2].commandObj.vestings[0].to).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[2].commandObj.vestings[1].to).toBe("0xee0B645Bb006d9bcE9227Ba53E31D117D533eF5c");
    expect(parsed.solutions[2].commandObj.vestings[0].vesting).toBe(10000);
    expect(parsed.solutions[2].commandObj.vestings[1].vesting).toBe(200);
    expect(!!parsed.solutions[2].lawObj).toBe(false);
  });
});

describe('Dismissal of Ship Management', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/sma_dismissal.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("The Ship Management Administration is imcompetent!");
  });

  it('has some solutions', () => {
    expect(parsed.solutions[0].commandObj.assign.subsetAddr).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.assign.newOfficer).toBe("jiro.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.assign.subsetAddr).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.assign.newOfficer).toBe("saburo.aogashima.onthe.eth");
    expect(parsed.solutions[2].commandObj.assign.subsetAddr).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[2].commandObj.assign.newOfficer).toBe("shiro.aogashima.onthe.eth");
  });

});

describe('Law addition without the command', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/sma_only_laws.leg').toString());
  it('has a problem', () => {
    expect(parsed.problem).toBe("Ships are dangerous in these days!");
  });
  it('has laws', () => {
    expect(parsed.solutions[0].lawObj.id).toBe("LAW_ID_NEW");
    expect(parsed.solutions[0].lawObj.lawName).toBe("Prohibition of the ships");
    expect(parsed.solutions[0].lawObj.laws[0]).toBe("You can't have any ships.");
  });
})
describe('Law overwrite without the command', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/sma_update_laws.leg').toString());
  it('has a problem', () => {
    expect(parsed.problem).toBe("Ships are dangerous in these days!");
  });
  it('has laws', () => {
    expect(parsed.solutions[0].lawObj.id).toBe(108);
    expect(parsed.solutions[0].lawObj.lawName).toBe("Prohibition of the ships");
    expect(parsed.solutions[0].lawObj.laws[0]).toBe("You can't have any ships.");
  });
})



describe('Negative Vesting of Ship Management', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/sma_negative_vesting.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("The Ship Management Administration is imcompetent!");
  });

  it('has some solutions', () => {
    expect(parsed.solutions[0].commandObj.vestings[0].to).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.vestings[0].vesting).toBe(-100);
    expect(parsed.solutions[1].commandObj.vestings[0].to).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.vestings[0].vesting).toBe(-250);
    expect(parsed.solutions[2].commandObj.assign.subsetAddr).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[2].commandObj.assign.newOfficer).toBe("jiro.aogashima.onthe.eth");
  });

});

describe('Budget top-up of Ship Management', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/sma_topup.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("The Ship Management Administration is excellent and we have to invest more!");
  });

  it('has some solutions', () => {
    expect(parsed.solutions[0].commandObj.vestings[0].to).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.vestings[0].vesting).toBe(1000);
    expect(parsed.solutions[1].commandObj.vestings[0].to).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.vestings[0].vesting).toBe(2000);
    expect(parsed.solutions[2].commandObj.vestings[0].to).toBe("shipCo.aogashima.onthe.eth");
    expect(parsed.solutions[2].commandObj.vestings[0].vesting).toBe(4000);
  });

});

describe('Single Member Facilitator Assgnment Proposal', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/cro_facilitator_add.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("A facilitator has been retired and a replacement is required.");
  });

  it('has some candidates', () => {
    expect(parsed.solutions[0].commandObj.vestings[0].to).toBe("taro.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.vestings[0].vesting).toBe(20000);
    expect(parsed.solutions[0].commandObj.vestings[0].term).toBe(4);
    expect(parsed.solutions[1].commandObj.vestings[0].to).toBe("jiro.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.vestings[0].vesting).toBe(14000);
    expect(parsed.solutions[1].commandObj.vestings[0].term).toBe(3);
  });
  
})


describe('Multi Member Professional Assgnment Proposal', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/cro_professionals_multi.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("High demand for financial system professionals!");
  });

  it('has some candidates', () => {
    expect(parsed.solutions[0].commandObj.vestings[0].to).toBe("alice.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.vestings[0].vesting).toBe(20000);
    expect(parsed.solutions[0].commandObj.vestings[0].term).toBe(4);
    expect(parsed.solutions[0].commandObj.vestings[1].to).toBe("bob.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.vestings[1].vesting).toBe(20000);
    expect(parsed.solutions[0].commandObj.vestings[1].term).toBe(4);
    expect(parsed.solutions[0].commandObj.vestings[2].to).toBe("carl.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.vestings[2].vesting).toBe(20000);
    expect(parsed.solutions[0].commandObj.vestings[2].term).toBe(4);

    expect(parsed.solutions[1].commandObj.vestings[0].to).toBe("taro.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.vestings[0].vesting).toBe(14000);
    expect(parsed.solutions[1].commandObj.vestings[0].term).toBe(3);
    expect(parsed.solutions[1].commandObj.vestings[1].to).toBe("jiro.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.vestings[1].vesting).toBe(14000);
    expect(parsed.solutions[1].commandObj.vestings[1].term).toBe(3);
    expect(parsed.solutions[1].commandObj.vestings[2].to).toBe("saburo.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.vestings[2].vesting).toBe(14000);
    expect(parsed.solutions[1].commandObj.vestings[2].term).toBe(3);
  });
  
})

describe('Single Member Supreme Judge Assgnment Proposal', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/cro_supreme_judge_add.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("A judge has been retired and a replacement is required.");
  });

  it('has some candidates', () => {
    expect(parsed.solutions[0].commandObj.vestings[0].to).toBe("goro.aogashima.onthe.eth");
    expect(parsed.solutions[0].commandObj.vestings[0].vesting).toBe(20000);
    expect(parsed.solutions[0].commandObj.vestings[0].term).toBe(10);
    expect(parsed.solutions[1].commandObj.vestings[0].to).toBe("shiro.aogashima.onthe.eth");
    expect(parsed.solutions[1].commandObj.vestings[0].vesting).toBe(24000);
    expect(parsed.solutions[1].commandObj.vestings[0].term).toBe(10);
  });
  
})

describe('Variable Update Proposal', () => {
  const parsed = global.parser.parse(readFileSync('./aogashima/laws/variable_update.leg').toString());

  it('has a problem', () => {
    expect(parsed.problem).toBe("Aogashima DADDS has to be neo-reactionary?");
  });

  it('has some candidates', () => {
    let vars = parsed.solutions[0].commandObj;
const VARS = `CRKYC_DAILY_CITIZEN_DEREGISTRATABLE_RATE = 5
FACILITATOR_TERM = 4
FACILITATOR_ANNUAL_COMPENSATION = 200000
FACILITATOR_ASSIGNMENT_DELIBERATION_DURATION = 10
FACILITATOR_ASSIGNMENT_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE = 33
FACILITATOR_ASSIGNMENT_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE = 50
FACILITATOR_VOTING_POWER = 0
PROFESSIONAL_TERM = 7
PROFESSIONAL_ANNUAL_COMPENSATION = 140000
PROFESSIONAL_ASSIGNMENT_DELIBERATION_DURATION = 14
PROFESSIONAL_ASSIGNMENT_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE = 33
PROFESSIONAL_ASSIGNMENT_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE = 50
PROFESSIONAL_VOTING_POWER = 0
EMERGENCY_PROFESSIONAL_HEADCOUNT = 100
SUPREME_JUDGE_TERM = 10
SUPREME_JUDGE_ANNUAL_COMPENSATION = 320000
SUPREME_JUDGE_ASSIGNMENT_DELIBERATION_DURATION = 14
SUPREME_JUDGE_ASSIGNMENT_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE = 33
SUPREME_JUDGE_ASSIGNMENT_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE = 50
NORMAL_DELIBERATION_TERM = 14
NORMAL_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE = 25
NORMAL_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE = 50
HEAVY_DELIBERATION_TERM = 60
HEAVY_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE = 66
HEAVY_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE = 50
HEAVY_DELIBERATION_TRIGGERING_TREASURY_EXPOSURE_RATE = 1
CURRENCY_ISSUANCE_DELIBERATION_TERM = 14
CURRENCY_ISSUANCE_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE = 33
CURRENCY_ISSUANCE_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE = 50
DISMISSAL_DELIBERATION_TERM = 3
DISMISSAL_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE = 33
DISMISSAL_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE = 50
DAILY_DELIBERATION_REWARD = 500
MIXING_REWARD = 50`
    var res = vars.map(a=> `${Object.keys(a)} = ${a[Object.keys(a)]}` ).join("\n")
    
    expect(res).toBe(VARS);
  });
  
})