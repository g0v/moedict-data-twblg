import ::
	for x in *.csv ; do \
	    curl -i -H "Content-Type: text/csv" -X PUT -d @$$x http://127.0.0.1:3000/collections/$$(echo $$x | perl -pe 's/[-x.csv]//g') \
	; done

