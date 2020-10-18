all :: import deps dict index

deps ::
	npm i

import ::
	-rm twblg.db
	sqlite3 twblg.db < sqlite3-init.sql

dict ::
	./gen.ls > dict-twblg.json
	./gen-ext.ls > dict-twblg-ext.json # get definitions from dict-concised

index ::
	sqlite3 twblg.db "SELECT DISTINCT 詞目 title from entries WHERE 屬性 IN ('1','2','5','25') ORDER BY 詞目" | perl -0777 -pe 'chop;s/\n/",\n"/g;print q!["!;END{print q!"]!}' > index.json

#x-筆畫.csv :: ../moedict-webkit/dict-revised.pua.json
#	./stroke-from-revised.ls

x-筆畫.csv :: node_modules/cjk-unihan/data/unihan.db ./strokes-from-unihan.pl
	./strokes-from-unihan.pl > x-筆畫.csv
