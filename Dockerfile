FROM node:alpine
RUN apk add --update LiveScript
RUN apk add --update make
RUN apk add --update sqlite
RUN apk add --update perl
RUN npm install https://github.com/mapbox/node-sqlite3/tarball/master
# RUN npm install -g sqilte3
RUN npm install unorm
COPY . .
RUN make all
RUN sed 's/\r//g' -i dict-twblg.json
RUN sed 's/\r//g' -i index.json

