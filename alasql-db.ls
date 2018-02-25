require! <[ fs alasql ]>
csv-to-json = require \csv-parse/lib/sync

export db = new alasql.Database
for table, file of TableToFile!
  data = fs.readFileSync file
  db.exec "CREATE TABLE #table"
  db.tables[table].data = csv-to-json data, {columns: -> esc(it).split /,/ }

export function esc (u)
  escape(u).replace(/%([0-9A-F]{2})/g (,h) -> String.fromCharCode(parseInt h, 16)).replace(/%/g, '_')

function TableToFile => {
  pua: "x-造字.csv"
  m2t: "uni/對應華語.csv"
  examples: "uni/例句.csv"
  heteronyms: "uni/又音.csv"
  definitions: "uni/釋義.csv"
  definitions_parts: "uni/釋義.詞性對照.csv"
  entries: "uni/詞目總檔.csv"
  antonyms: "uni/反義詞對應.csv"
  lingos: "uni/詞彙方言差.csv"
  dialects: "uni/語音方言差.csv"
  synonyms: "uni/近義詞對應.csv"
}
