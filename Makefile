import ::
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @x-造字.csv http://127.0.0.1:3000/collections/pua -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @x-華語對照表.csv http://127.0.0.1:3000/collections/m2t -o /dev/null
#	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/例句.csv http://127.0.0.1:3000/collections/examples -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/又音.csv http://127.0.0.1:3000/collections/heteronyms -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/又音.屬性對照.csv http://127.0.0.1:3000/collections/heteronyms_attrs -o /dev/null
#	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/釋義.csv http://127.0.0.1:3000/collections/definitions -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/釋義.詞性對照.csv http://127.0.0.1:3000/collections/definitions_parts -o /dev/null
#	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/詞目總檔.csv http://127.0.0.1:3000/collections/entries -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/詞目總檔.屬性對照.csv http://127.0.0.1:3000/collections/entries_attrs -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/反義詞對應.csv http://127.0.0.1:3000/collections/antonyms -o /dev/null
#	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/詞彙方言差.csv http://127.0.0.1:3000/collections/lingos -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/語音方言差.csv http://127.0.0.1:3000/collections/dialects -o /dev/null
	curl -i -H "Content-Type: text/csv" -X PUT --data-binary @uni/近義詞對應.csv http://127.0.0.1:3000/collections/synonyms -o /dev/null
