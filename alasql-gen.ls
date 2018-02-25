#!/usr/bin/env lsc -p
{ db, escm, stmt } = require './alasql-db.ls'

console.log stmt
process.exit!

db.exec(esc "CREATE INDEX idx_a ON antonyms(主編碼)")
db.exec(esc "CREATE INDEX idx_s ON synonyms(主編碼)")

x <- db.exec(esc """
  SELECT DISTINCT 詞目 title, MAX(部首) radical FROM entries
   WHERE 屬性 IN ('1', '25')
   GROUP BY 詞目
   ORDER BY 詞目
""").map

unless x.radical
  delete x.strokes
  delete x.radical

x.heteronyms = db.exec(esc("""
  SELECT 主編碼 id
    FROM entries
   WHERE 詞目 = ?
"""), [x.title])
/*
x.heteronyms = db.exec(esc("""
  SELECT 主編碼 id, 音讀 trs, 文白 reading,
           (SELECT ARRAY( 反義詞對應 ) FROM antonyms WHERE 主編碼 = entries.主編碼) antonyms,
           (SELECT ARRAY( 近義詞對應 ) FROM synonyms WHERE 主編碼 = entries.主編碼) synonyms
    FROM entries
   WHERE 詞目 = ? AND 屬性 IN ('1', '25')
   ORDER BY 主編碼
"""), [x.title]).map (nym) ->
  if nym.antonyms
    nym.antonyms = db.exec(esc("""
      SELECT 詞目 title FROM entries WHERE 主編碼 IN (
    """) + nym.antonyms.map(->"'#it'").join(',') + ")").map((.title)).join(',')
  if nym.synonyms
    nym.synonyms = db.exec(esc("""
      SELECT 詞目 title FROM entries WHERE 主編碼 IN (
    """) + nym.synonyms.map(->"'#it'").join(',') + ")").map((.title)).join(',')
  if +nym.reading
    nym.reading = ".文白俗替"[nym.reading]
  else
    delete nym.reading
  nym.definitions = db.exec(esc("""
    SELECT (SELECT dp.詞性 FROM definitions_parts dp WHERE dp.代號 = definitions.詞性代碼) AS type, 釋義 def,
           (SELECT array_agg(
             '\uFFF9' || 例句 || '\uFFFA' || 例句標音 || '\uFFFB' || 華語翻譯
           ) FROM examples WHERE examples.釋義編號 = definitions.釋義編號) example
      FROM definitions
     WHERE 主編號 = ?
     ORDER BY 釋義順序
  """), [nym.id]).map (def) ->
    delete def.example unless def.example?length
    def
  delete nym.synonyms unless nym.synonyms
  delete nym.antonyms unless nym.antonyms
  nym
*/
console.log JSON.stringify(x)
