.mode csv
.header on
.import 'x-筆畫.csv' strokes
.import 'x-造字.csv' pua
.import 'uni/對應華語.csv' m2t
.import 'uni/例句.csv' examples
.import 'uni/又音.csv' heteronyms
.import 'uni/釋義.csv' definitions
.import 'uni/釋義.詞性對照.csv' definitions_parts
.import 'uni/詞目總檔.csv' entries
.import 'uni/反義詞對應.csv' antonyms
.import 'uni/詞彙方言差.csv' lingos
.import 'uni/語音方言差.csv' dialects
.import 'uni/近義詞對應.csv' synonyms
CREATE INDEX idx_主編碼 ON entries(主編碼);
CREATE INDEX idx_詞目 ON entries(詞目);
CREATE INDEX idx_屬性 ON entries(屬性);
CREATE INDEX idx_a ON antonyms(主編碼);
CREATE INDEX idx_s ON synonyms(主編碼);
CREATE INDEX idx_title ON strokes(title);
