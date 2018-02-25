#!/usr/bin/env lsc
dict-revised = require '../moedict-webkit/dict-revised.pua.json'
console.log "title,radical,non_radical_stroke_count,stroke_count"
for { non_radical_stroke_count, radical, stroke_count, title } in dict-revised | stroke_count
  console.log "#title,#radical,#non_radical_stroke_count,#stroke_count" unless title is /^{/
