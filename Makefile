all ::
	@echo "# make deps ; make pgrest ; make import ; make dict ; make index"

deps ::
	npm i -g pgrest plv8x

pgrest ::
	-dropdb twblg
	createdb -E UTF8 twblg
	pgrest --db twblg

import ::
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @x-造字.csv http://127.0.0.1:3000/collections/pua -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/對應華語.csv http://127.0.0.1:3000/collections/m2t -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/例句.csv http://127.0.0.1:3000/collections/examples -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/又音.csv http://127.0.0.1:3000/collections/heteronyms -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/又音.屬性對照.csv http://127.0.0.1:3000/collections/heteronyms_attrs -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/釋義.csv http://127.0.0.1:3000/collections/definitions -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/釋義.詞性對照.csv http://127.0.0.1:3000/collections/definitions_parts -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/詞目總檔.csv http://127.0.0.1:3000/collections/entries -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/詞目總檔.屬性對照.csv http://127.0.0.1:3000/collections/entries_attrs -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/反義詞對應.csv http://127.0.0.1:3000/collections/antonyms -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/詞彙方言差.csv http://127.0.0.1:3000/collections/lingos -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/語音方言差.csv http://127.0.0.1:3000/collections/dialects -o /dev/null
	curl -i -H "Content-Type: text/csv" -X POST --data-binary @uni/近義詞對應.csv http://127.0.0.1:3000/collections/synonyms -o /dev/null

dict ::
	./gen.ls > k
	lsc -je 'JSON.parse require(\unorm).nfd require(\fs).read-file-sync \k \utf8' > dict-twblg.json
	# XXX - TODO - gen strokes from dict revised
	./gen-ext.ls > k-ext
	lsc -je 'JSON.parse require(\unorm).nfd require(\fs).read-file-sync \k-ext \utf8' > dict-twblg-ext.json

index ::
	plv8x -d twblg -je '~> [title for {title} in plv8.execute("SELECT DISTINCT 詞目 title from entries WHERE 屬性::int IN (1,2,5,25)  ORDER BY 詞目") | title isnt /[⿰⿸]/]' > index.json
