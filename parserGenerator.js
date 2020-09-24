import pegjs from 'pegjs';
import { readFileSync, writeFileSync } from 'fs'
const filename = process.argv[2]

var parser = pegjs.generate(readFileSync(`./${filename}.pegjs`).toString(), {output: 'source'});

console.log( parser.length > 30 ? "Generated" : "maybe failed" )
writeFileSync(`./${filename}.js`, `global.parser = \n\n\n${parser}`);