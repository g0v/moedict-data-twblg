#!/usr/bin/env plv8x -d x -jr
x <- plv8.execute """
  SELECT DISTINCT 詞目 title, 部首 radical, 部首序 strokes FROM entries
   WHERE 屬性::int IN (1,25)
   ORDER BY 詞目
""" .map
if x.radical
  [j,sc,nrsc] = delete x.strokes / \-
  x.stroke_count = +sc
  x.non_radical_stroke_count = +nrsc
else delete x<[ strokes radical ]>
x.heteronyms = plv8.execute """
  SELECT 主編號 id, 音讀 trs, 文白俗替 reading, 方言差 dialects
    FROM entries
   WHERE 詞目 = $1 AND 屬性::int IN (1,25)
   ORDER BY 主編號
""" [x.title] .map (nym) ->
  if nym.dialects
    nym.dialects = plv8.execute """
      SELECT 鹿港,三峽,臺北,宜蘭,臺南,高雄,金門,馬公,新竹,臺中
        FROM #{ if that is /^\[方1\]/ then \lingos else \dialects }
       WHERE #{ if that is /^\[方1\]/ then \詞彙編號 else \字號 } = $1
    """ [that] .0
  else delete nym.dialects
  delete nym.reading unless nym.reading
  nym.definitions = plv8.execute """
    SELECT (SELECT _1 FROM definitions_parts WHERE _0 = 詞性) AS type, 釋義 def,
           (SELECT string_agg(
             (SELECT 詞目 FROM entries WHERE 主編號 = 反義詞), ','
           ) FROM antonyms WHERE 主編號 = definitions.主編號) antonyms,
           (SELECT string_agg(
             (SELECT 詞目 FROM entries WHERE 主編號 = 近義詞對應), ','
           ) FROM synonyms WHERE 主編號 = definitions.主編號) synonyms,
           (SELECT array_agg(
             '\uFFF9' || 例句 || '\uFFFA' || 標音 || '\uFFFB' || 例句翻譯
           ) FROM examples WHERE 釋義編號 = definitions.流水號) example
      FROM definitions
     WHERE 主編號 = $1
     ORDER BY 義項順序
  """ [nym.id] .map (def) ->
    delete def.example unless def.example?length
    delete def.synonyms unless def.synonyms
    delete def.antonyms unless def.antonyms
    def
  delete nym.id
  nym
return x
