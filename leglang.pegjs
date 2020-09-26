Expression
  = __ head: Problem __ tail: Solutions { 
  var i;
  var arr = squash(tail.solutions)
  var res=new Array(arr.length);

  for(i=0;i<arr.length;i++){
    var item = squash(arr[i])
    item = item[0]
    item = squash(item)
    res[i] = item
  }
  
  function squash(o){  	
  	return o && typeof o === 'array' ? o.map(a=>typeof a === 'array'?a.filter(b=>b):a).filter(a=>a) : o
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

String "string"
  = _ ([a-zA-Z0-9!?_\\-\\$\\.\\:\\=\[\]\{\}\,]+_?)+ { return text(); }

_ "whitespace"
  = [ \t]* { return }

__ "newline"
  = [\n\r]* { return }

Solutions
  = SHARP _ head:"solutions" tail:(__ _ A_SOLUTION)+ {
    return {
      solutions: tail.map(a=> a.filter(b=>b)[0] )
    }
  }
  
  
A_SOLUTION
  = head:(
    SolutionName
    HeaderClause
    LawClause? _ __) {
      return {
        solutionName: head[0],
        headerObj: head[1],
        lawObj: head[2]
      }
    }

HeaderClause = head:(
	TSHARP HeaderTitle
  	(HeaderLogic)+
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
  = head:(String _ __) { return head.filter(a=>a)[0] }
 
BulletPoints
  = BulletLine+
BulletLine = head:(_ TICK _ __ String __ ){ return head.filter(a=>a)[0] }
 
TICK
  = "-" { return }
 
 
SHARP
  = "#" { return }

DSHARP
  = "##" { return }

TSHARP
  = "###" { return }
  
QSHARP
  = "####" { return }

EOL
   = [ \t\n\r]+ { return }