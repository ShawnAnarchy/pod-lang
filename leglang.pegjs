// Simple Arithmetics Grammar
// ==========================
//
// Accepts expressions like "2 * (3 + 4)" and computes their value.

Expression
  = head:Problem tail:(_ ":" _ Item) {
      return {
      	problem: tail[3]
      }
    }

Problem
  = _ "problem" _ { return "problem" }

Item
  = _ expr:Expression _ { return expr; }
  / String

String "string"
  = _ ([a-zA-Z0-9!?_-]+_?)+ { return text(); }

_ "whitespace"
  = [ \t\n\r]*