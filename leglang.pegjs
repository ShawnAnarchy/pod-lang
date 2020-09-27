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
    HeaderClause?
    LawClause? _ __) {
      return {
        solutionName: head[0],
        headerObj: head[1],
        lawObj: head[2]
      }
    }

HeaderClause = head:(
	TSHARP HeaderTitle
  	HeaderLogic
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
HeaderTitle = String _ __ { return }
LawPlaceholder = String  _ __ { return }
_LawTitle = head:(String  _ __) { return head.filter(a=>a)[0].trim() }
LawTitle = head:(QSHARP _LawTitle) { return head.filter(a=>a)[0].trim() }
HeaderLogic
  = "Subset.new" head:SubsetName _ __ tail:HeaderLogic* {
  	return { new: head, assign: "", vestings: tail[0].vestings }
  }
  / "Subset.assign" _ head:HeaderAddressExpression _ __ tail:HeaderLogic* {
  	return { new: "", assign: head, vestings: tail[0].vestings }
  }
  / "Subset.replaceOfficerBySubsetId" _ subsetAddr:HeaderAddressExpression _ Comma _ newOfficer:HeaderAddressExpression _ __ tail:HeaderLogic* {
  	return { new: "", assign: { subsetAddr:subsetAddr, newOfficer: newOfficer }, vestings: tail[0] ? tail[0].vestings : [] }
  }
  / "Vesting.set" _ main:HeaderTxsExpression _ __ {
  	return { new: "", assign: "", vestings: main.filter(a=>a) }
  }
SubsetName = _ __ '"' ([a-zA-Z0-9_] _)+ '"' _ __ { return text().replace(/("|\n)/g, "").trim() }
HeaderAddressExpression = NONE / AddressString / ENSString { return text() }
HeaderTxsExpression =
	LSq main:HeaderTxsExpression RSq { return main } /
    main:(TxObj)+ { return main }

TxObj = LWavy to:TxToExpression Comma vesting:TxVestingExpression RWavy Comma? {
	return { to:to, vesting:vesting }
}
TxToExpression
	= "to =" _ main:NEW_SUBSET { return "NEW_SUBSET" } /
      "to =" _ main:AddressString { return main } / 
	  "to =" _ main:ENSString { return main } 
TxVestingExpression
	= "vesting =" _ main:([0-9,]+) " DAI per month" {
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
  = _ ([a-zA-Z0-9!?_\\-\\$\\.\\:\\=\[\]\{\}\,\']+_?)+ { return text().trim(); }
ExprString "Expression String"
  = _ ([a-zA-Z0-9!?_\\$\\.\\:\[\]\{\}\,]+_?)+ { return text().trim(); }
AddressString "Address String"
  = _ ("0x"[a-zA-Z0-9]+) _ { return text().trim(); }
ENSString "ENS String"
  = _ ([a-zA-Z0-9]+ ".")+ "eth" _ { return text().trim(); }
NEW_SUBSET "New Subset Reserved Constant" = _ "NEW_SUBSET" _ { return text().trim() }
NONE "None type" = _ "None" _ { return text().trim() }