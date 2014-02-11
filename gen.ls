#!/usr/bin/env plv8x -d x -jr
x <- plv8.execute """
  SELECT DISTINCT 詞目 title, MAX(部首) radical, MAX(部首序) strokes FROM entries
   WHERE 屬性代號::int IN (1,25)
   GROUP BY 詞目
   ORDER BY 詞目
""" .map
if x.radical
  [j,nrsc,sc] = delete x.strokes / \-
  x.stroke_count = +sc
  x.non_radical_stroke_count = +nrsc
else delete x<[ strokes radical ]>
x.heteronyms = plv8.execute """
  SELECT 主編號 id, 音讀 trs, 文白 reading, 方言差對應 dialects,
           (SELECT string_agg(
             (SELECT 詞目 FROM entries WHERE 主編號 = 反義詞詞目編號), ','
           ) FROM antonyms WHERE 主編號 = entries.主編號) antonyms,
           (SELECT string_agg(
             (SELECT 詞目 FROM entries WHERE 主編號 = 近義詞編號), ','
           ) FROM synonyms WHERE 主編號 = entries.主編號) synonyms
    FROM entries
   WHERE 詞目 = $1 AND 屬性代號::int IN (1,25)
   ORDER BY 主編號
""" [x.title] .map (nym) ->
  if nym.dialects
    nym.dialects = plv8.execute """
      SELECT 鹿港,三峽,臺北,宜蘭,臺南,高雄,金門,馬公,新竹,臺中
        FROM #{ if that is /^\[方1\]/ then \lingos else \dialects }
       WHERE #{ if that is /^\[方1\]/ then \資料編號 else \字號 } = $1
    """ [that] .0
  else delete nym.dialects
  delete nym.reading unless nym.reading
  nym.definitions = plv8.execute """
    SELECT (SELECT dp.詞性 FROM definitions_parts dp WHERE dp.代號 = definitions.詞性) AS type, 釋義 def,
           (SELECT array_agg(
             '\uFFF9' || 例句 || '\uFFFA' || 拼音 || '\uFFFB' || 翻譯
           ) FROM examples WHERE examples.釋義編號 = definitions.釋義編號) example
      FROM definitions
     WHERE 主編號 = $1
     ORDER BY 釋義序
  """ [nym.id] .map (def) ->
    delete def.example unless def.example?length
    def
  delete nym.synonyms unless nym.synonyms
  delete nym.antonyms unless nym.antonyms
  nym
return x
