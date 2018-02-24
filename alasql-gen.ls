#!/usr/bin/env lsc

require! <[ fs alasql ]>
csv-to-json = require \csv-parse/lib/sync
file = 'pua/詞目總檔.csv'
data = fs.readFileSync file
entries = csv-to-json data, {columns: -> esc(it).split /,/ }

db = new alasql.Database
db.exec 'CREATE TABLE entries'
db.tables.entries.data = entries

res = db.exec esc """
  SELECT DISTINCT 詞目 title, MAX(部首) radical FROM entries
   WHERE 屬性::int IN (1,25)
   GROUP BY 詞目
   ORDER BY 詞目
"""
console.log res

function esc (u)
  escape(u).replace(/%([0-9A-F]{2})/g (,h) -> String.fromCharCode(parseInt h, 16)).replace(/%/g, '_')
