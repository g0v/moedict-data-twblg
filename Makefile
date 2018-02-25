all ::
	@echo "# make deps ; make pgrest ; make import ; make dict ; make index"

deps ::
	npm i -g sqlite3

pgrest ::
	-dropdb twblg
	createdb -E UTF8 twblg
	pgrest --db twblg

import ::
	-rm twblg.db
	sqlite3 twblg.db < sqlite3-init.sql

dict ::
	#./gen.ls > k
	lsc -pe 'JSON.stringify(JSON.parse("[#{(require(\unorm).nfd require(\fs).read-file-sync \k \utf8).replace(/\n/g, \,).slice(0, -1)}]"),,2)' > dict-twblg.json
	# XXX - TODO - gen strokes from dict revised
	#./gen-ext.ls > k-ext
	#lsc -je 'JSON.parse require(\unorm).nfd require(\fs).read-file-sync \k-ext \utf8' > dict-twblg-ext.json

index ::
	plv8x -d twblg -je '~> [title for {title} in plv8.execute("SELECT DISTINCT 詞目 title from entries WHERE 屬性::int IN (1,2,5,25)  ORDER BY 詞目") | title isnt /[⿰⿸]/]' > index.json
