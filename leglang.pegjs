Expression
  = __ head: Problem __ tail: Solutions { 
  var i;
  var arr = tail.solutions.filter(a=>a)[0].filter(a=>a);
  var res=new Array(arr.length);

  for(i=0;i<arr.length;i++){
    var item = arr[i].filter(b=>b)[0]
    res[i] = item
  }
  
  return {
    problem: head.problem,
    solutions: res
  }
}

Problem
  = head:"problem" tail:(_ ":" _ Item) {
      return {
      	problem: tail[3]
      }
    }

Item
  = _ expr:Expression _ { return expr; }
  / String

String "string"
  = _ ([a-zA-Z0-9!?_\\-\\$\\.\\:]+_?)+ { return text(); }

_ "whitespace"
  = [ \t]* { return }

__ "newline"
  = [\n\r]* { return }

Solutions
  = head:"solutions" tail:(_ COLON __ _ BulletPoints) {
    return {
      solutions: tail
    }
  }
  
 BulletPoints
   = (_ TICK _ Item __ / EOL )+
 
 TICK
   = "-" { return }
 
 
 COLON
   = ":" { return }
 EOL
   = [ \t\n\r]+ { return }