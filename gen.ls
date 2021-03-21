#!/usr/bin/env lsc
sqlite3 = require('sqlite3').verbose!
db = new sqlite3.Database('twblg.db', sqlite3.OPEN_READONLY)

stmt-ent = db.prepare """
    SELECT 主編碼 id, 音讀 trs, 文白屬性 reading, -- 方言差對應 dialects,
             (SELECT group_concat(
               (SELECT 詞目 FROM entries WHERE 主編碼 = 反義詞對應), ','
             ) FROM antonyms WHERE 主編碼 = entries.主編碼) antonyms,
             (SELECT group_concat(
               (SELECT 詞目 FROM entries WHERE 主編碼 = 近義詞對應), ','
             ) FROM synonyms WHERE 主編碼 = entries.主編碼) synonyms
      FROM entries
     WHERE 詞目 = ? AND 屬性 IN ('1', '25')
     ORDER BY 主編碼
"""

stmt-nym = db.prepare """
        SELECT (SELECT dp.正確 FROM definitions_parts dp WHERE dp.詞性代號 = definitions.詞性代號) AS type, 釋義 def,
               (SELECT group_concat(
                 ('\uFFF9' || 例句 || '\uFFFA' || 例句標音 || '\uFFFB' || 華語翻譯), ';;;'
               ) FROM examples WHERE examples.釋義編號 = definitions.釋義總序號) example
          FROM definitions
         WHERE 主編碼 = ?
         ORDER BY 釋義順序
"""

(, res) <- db.all """
  SELECT DISTINCT 詞目 title, radical, non_radical_stroke_count, stroke_count FROM entries
   LEFT JOIN strokes on entries.詞目 = strokes.title
   WHERE 屬性 IN ('1', '25')
   GROUP BY 詞目
   ORDER BY 詞目
""", []
for let x in res
  x.heteronyms = []
  (,ns) <- stmt-ent.all [x.title]
  for let nym in ns
    if +nym.reading
      nym.reading = ".文白俗替"[nym.reading]
    else
      delete nym.reading
    delete nym.synonyms unless nym.synonyms
    delete nym.antonyms unless nym.antonyms
    (,ds) <- stmt-nym.all [nym.id]
    nym.definitions = for let def in ds
      if def.example?length
        def.example = def.example.split /;;;/
      else
        delete def.example
      if def.type is \不標示
        delete def.type
      def
    x.heteronyms.push nym
  if x.radical
    x.stroke_count = +delete x.stroke_count
    x.non_radical_stroke_count = +delete x.non_radical_stroke_count
  else
    delete x.strokes
    delete x.radical
    delete x.stroke_count
    delete x.non_radical_stroke_count
db.close -> console.log require(\unorm).nfd JSON.stringify(res,, 2)
