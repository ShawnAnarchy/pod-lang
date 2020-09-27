Main
  = __ head: Problem __ tail: Solutions? { 
  if(!tail){
    return {
      problem: head.problem,
      solutions: []
    }
  }

  function squash(o){  	
  	return o && typeof o === 'array' ? o.map(a=>typeof a === 'array'?a.filter(b=>b):a).filter(a=>a) : o
  }

  var i;
  var arr = squash(tail.solutions)
  var res=new Array(arr.length);

  for(i=0;i<arr.length;i++){
    var item = squash(arr[i])
    item = item[0]
    item = squash(item)
    res[i] = item
  }
  
  
  return {
    problem: head.problem,
    solutions: tail.solutions
  }
}

Problem
  = SHARP _ head:"problem" tail:(_ __ String) {
      return {
      	problem: tail[2]
      }
    }

Solutions
  = SHARP _ head:"solutions" tail:(__ _ A_SOLUTION)+ {
    return {
      solutions: tail.map(a=> a.filter(b=>b)[0] )
    }
  }
  
  
A_SOLUTION
  = head:(
    SolutionName
    TargetLawClause?
    CommandClause?
    LawClause? _ __) {
	  var lawObj = {}

      if (head[3]){
        lawObj.lawName = head[3][0][0]
        lawObj.laws = head[3][0][1]
        if (head[1]){
          lawObj.id = head[1]
        } else {
          lawObj.id = "LAW_ID_NEW"
        }
      } else {
        lawObj = undefined
      }
    
      return {
        solutionName: head[0],
        commandObj: head[2],
        lawObj: lawObj
      }
    }

CommandClause = head:(
	TSHARP CommandTitle
  	CommandLogic
  ) { return head.filter(a=>a)[0] }
LawClause = 
    head:(TSHARP LawPlaceholder
    ( LawTitle
      BulletPoints )+)
 	{
    	return head.filter(a=>a)[0]
    } 

SolutionName = head:(DSHARP _SolutionName) { return head.filter(a=>a)[0] }
_SolutionName = head:(_ String _ __) { return head.filter(a=>a)[0] }
CommandTitle = String _ __ { return }
LawPlaceholder = String  _ __ { return }
_LawTitle = head:(String  _ __) { return head.filter(a=>a)[0].trim() }
LawTitle = head:(QSHARP _LawTitle) { return head.filter(a=>a)[0].trim() }
TargetLawClause =  head:(_ __ TICK _ "TARGET_LAW_ID" _ "=" _ LAW_ID_EXPR _ __) { return parseInt(head.filter(a=>a)[2].join("")) }
LAW_ID_EXPR = [0-9]+

CommandLogic
  = "Subset.new" head:SubsetName _ __ tail:CommandLogic* {
  	return { new: head, assign: "", vestings: tail[0].vestings }
  }
  / "Subset.assign" _ head:CommandAddressExpression _ __ tail:CommandLogic* {
  	return { new: "", assign: head, vestings: tail[0].vestings }
  }
  / "Subset.replaceOfficerBySubsetId" _ subsetAddr:CommandAddressExpression _ Comma _ newOfficer:CommandAddressExpression _ __ tail:CommandLogic* {
  	return { new: "", assign: { subsetAddr:subsetAddr, newOfficer: newOfficer }, vestings: tail[0] ? tail[0].vestings : [] }
  }
  / "Vesting.set" _ main:CommandTxsExpression _ __ {
  	return { new: "", assign: "", vestings: main.filter(a=>a) }
  }
  / "Vesting.add" _ main:CommandTxsExpression _ __ {
  	return { new: "", assign: "", vestings: main.filter(a=>a) }
  }
  / "Vesting.sub" _ main:CommandTxsExpression _ __ {
  	return { new: "", assign: "", vestings: main.filter(a=>a) }
  }
  / "Facilitator.set" _ main:CommandTxsExpression _ __ {
  	return { new: "", assign: "", vestings: main.filter(a=>a) }
  }
  / "Professional.set" _ main:CommandTxsExpression _ '\"'tag:[a-zA-Z0-9_\ ]+'"' __ {
  	return { new: "", assign: "", vestings: main.filter(a=>a), tag:tag.join("") }
  }  
  / "SupremeJudge.set" _ main:CommandTxsExpression _ __ {
  	return { new: "", assign: "", vestings: main.filter(a=>a) }
  }  
  / head:(DELIBERATION_VARIABLES __)+  {
    return head.map(a=>a[0])
  }
  
DELIBERATION_VARIABLES =
    key:"CRKYC_DAILY_CITIZEN_DEREGISTRATABLE_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"FACILITATOR_TERM" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"FACILITATOR_ANNUAL_COMPENSATION" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"FACILITATOR_ASSIGNMENT_DELIBERATION_DURATION" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"FACILITATOR_ASSIGNMENT_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"FACILITATOR_ASSIGNMENT_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"FACILITATOR_VOTING_POWER" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"PROFESSIONAL_TERM" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"PROFESSIONAL_ANNUAL_COMPENSATION" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"PROFESSIONAL_ASSIGNMENT_DELIBERATION_DURATION" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"PROFESSIONAL_ASSIGNMENT_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"PROFESSIONAL_ASSIGNMENT_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"PROFESSIONAL_VOTING_POWER" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"EMERGENCY_PROFESSIONAL_HEADCOUNT" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"SUPREME_JUDGE_TERM" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"SUPREME_JUDGE_ANNUAL_COMPENSATION" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"SUPREME_JUDGE_ASSIGNMENT_DELIBERATION_DURATION" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"SUPREME_JUDGE_ASSIGNMENT_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"SUPREME_JUDGE_ASSIGNMENT_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"NORMAL_DELIBERATION_TERM" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"NORMAL_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"NORMAL_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"HEAVY_DELIBERATION_TERM" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"HEAVY_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"HEAVY_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"HEAVY_DELIBERATION_TRIGGERING_TREASURY_EXPOSURE_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"CURRENCY_ISSUANCE_DELIBERATION_TERM" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"CURRENCY_ISSUANCE_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"CURRENCY_ISSUANCE_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"DISMISSAL_DELIBERATION_TERM" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"DISMISSAL_DELIBERATION_INITIAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"DISMISSAL_DELIBERATION_FINAL_JUDGE_APPROVAL_RATE" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"DAILY_DELIBERATION_REWARD" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }
  / key:"MIXING_REWARD" _ "=" _ value:[0-9]+ _ __ { var obj={};obj[key]=parseInt(value.join("")); return obj; }


SubsetName = _ __ '"' ([a-zA-Z0-9_] _)+ '"' _ __ { return text().replace(/("|\n)/g, "").trim() }
CommandAddressExpression = NONE / AddressString / ENSString { return text() }
CommandTxsExpression =
	LSq main:CommandTxsExpression RSq { return main } /
    main:(TxObj)+ { return main }

TxObj = LWavy to:TxToExpression Comma
		vesting:TxVestingExpression Comma?
        term:TxTermExpression?
        RWavy Comma? {
	return { to:to, vesting:vesting, term: term }
}
TxToExpression
	= "to"_"=" _ main:NEW_SUBSET { return "NEW_SUBSET" } /
      "to"_"=" _ main:AddressString { return main } / 
	  "to"_"=" _ main:ENSString { return main } 
TxVestingExpression
	= "vesting"_"=" _ main:([\-0-9,]+) _"DAI per month" {
    	return parseInt(main.toString().split(",").join(""))
    }
	/ "vesting"_"=" _ main:([\-0-9,]+) _"DAI" {
    	return parseInt(main.toString().split(",").join(""))
    }
TxTermExpression
	= "term"_"=" _ main:([0-9,]+) _"yrs" {
    	return parseInt(main.toString().split(",").join(""))
    }
    / "term"_"=" _ main:([0-9,]+) _"years" {
    	return parseInt(main.toString().split(",").join(""))
    } 

BulletPoints = BulletLine+
BulletLine = head:(_ TICK _ __ String __ ){ return head.filter(a=>a)[0] }
 
 
_ "whitespace" = [ \t]* { return }
__ "newline" = [\n\r]* { return }
TICK = "-" { return }
SHARP = "#" { return }
DSHARP = "##" { return }
TSHARP = "###" { return }
QSHARP = "####" { return }
EOL = [ \t\n\r]+ { return }
LWavy = _ __ "{" _ __ { return }
RWavy = _ __ "}" _ __ { return }
LSq = _ __ "[" _ __ { return }
RSq = _ __ "]" _ __ { return }
Comma = _ __ "," _ __ { return }
String "String"
  = _ ([a-zA-Z0-9!?_\-\$\.\:\=\[\]\{\}\,\']+_?)+ { return text().trim(); }
ExprString "Expression String"
  = _ ([a-zA-Z0-9!?_\$\.\:\[\]\{\}\,]+_?)+ { return text().trim(); }
AddressString "Address String"
  = _ ("0x"[a-zA-Z0-9]+) _ { return text().trim(); }
ENSString "ENS String"
  = _ ([a-zA-Z0-9]+ ".")+ "eth" _ { return text().trim(); }
NEW_SUBSET "New Subset Reserved Constant" = _ "NEW_SUBSET" _ { return text().trim() }
NONE "None type" = _ "None" _ { return text().trim() }