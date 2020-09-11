import pegjs from 'pegjs';
import { readFileSync, writeFileSync } from 'fs'
const filename = 'arithmetics'

var parser = pegjs.generate(readFileSync(`./${filename}.pegjs`).toString(), {output: 'source'});

console.log( parser.length > 30 ? "Generated" : "maybe failed" )
writeFileSync('./arithmetics.js', `global.parser = \n\n\n${parser}`);