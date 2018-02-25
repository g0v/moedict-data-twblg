all :: import dict index

deps ::
	npm i sqlite3

import ::
	-rm twblg.db
	sqlite3 twblg.db < sqlite3-init.sql

dict ::
	./gen.ls > dict-twblg.json
	# XXX - TODO - gen strokes from dict revised
	#./gen-ext.ls > k-ext
	#lsc -je 'JSON.parse require(\unorm).nfd require(\fs).read-file-sync \k-ext \utf8' > dict-twblg-ext.json

index ::
	sqlite3 twblg.db "SELECT DISTINCT 詞目 title from entries WHERE 屬性 IN ('1','2','5','25') ORDER BY 詞目" | grep -v '⿰\|⿸' | perl -0777 -pe 'chop;s/\n/",\n"/g;print q!["!;END{print q!"]!}' > index.json
