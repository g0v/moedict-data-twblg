#!/usr/bin/env plv8x -d x -jr
x <- plv8.execute """
  SELECT DISTINCT 詞目 title, MAX(部首) radical, MAX(部首序) strokes
  FROM entries
  LEFT JOIN m ON m.title = 詞目
   WHERE 屬性::int IN (2,5) AND m.heteronyms IS NOT NULL
   GROUP BY 詞目
   ORDER BY 詞目
""" .map
if x.radical
  [j,sc,nrsc] = delete x.strokes / \-
  x.stroke_count = +sc
  x.non_radical_stroke_count = +nrsc
else delete x<[ strokes radical ]>
x.heteronyms = plv8.execute """
  SELECT 主編號 id, 音讀 trs, 文白俗替 reading, 方言差 dialects, m.heteronyms ~> '@0.definitions.map -> def: it.definition' definitions
    FROM entries
  LEFT JOIN m ON m.title = 詞目
   WHERE 詞目 = $1 AND 屬性::int IN (2,5)
   ORDER BY 主編號
   LIMIT 1
""" [x.title] .map (nym) ->
  if nym.dialects
    nym.dialects = plv8.execute """
      SELECT 鹿港,三峽,臺北,宜蘭,臺南,高雄,金門,馬公,新竹,臺中
        FROM #{ if that is /^\[方1\]/ then \lingos else \dialects }
       WHERE #{ if that is /^\[方1\]/ then \詞彙編號 else \字號 } = $1
    """ [that] .0
  else delete nym.dialects
  delete nym.reading unless nym.reading
  nym.definitions = JSON.parse nym.definitions
  nym
return x
