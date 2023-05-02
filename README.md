這是將「教育部臺灣閩南語常用詞辭典」的 Excel 資料處理為機器比較容易再利用的 CSV 及 JSON 格式。

辭典本文的著作權為教育部所有，依「創用 CC 姓名標示-禁止改作 3.0 臺灣」授權條款釋出：

https://twblg.dict.edu.tw/holodict_new/compile1_6_1.jsp

「華語對照表」資料檔案不屬於教育部上述授權範圍，而是自網頁版自行取得，為非營利之教育目的，依著作權法第50條，「以中央或地方機關或公法人之名義公開發表之著作，在合理範圍內，得重製、公開播送或公開傳輸。」

此處轉換格式、重新編排的編輯著作權（如果有的話）由 唐鳳以 CC0 釋出。

### 發現資料錯誤更新方式
1. 可以先回報[教育部](https://email.moe.gov.tw/Home.aspx)
2. 然後再[申請新的資料](https://twblg.dict.edu.tw/holodict_new/compile1_6_1.jsp)下來
3. 將申請到的`ods`，轉成`csv`，放在`raw/`
4. 處理控制字元
```
sed 's/'$'\x02''//g' -i raw/*
sed 's/'$'\x0e''//g' -i raw/*
dos2unix raw/*
```
5. 用`csv2uni.pl`轉出`pua/`,`uni/`版本
6. PR更新專案資料

### 更新萌典
```
npm install # 安裝依賴
make import # 建立從原始檔匯入資料到 twblg.db
make dict # 產生 dict-twblg.json 和 dict-twblg-ext.json
```

或是用 Docker：

```
time docker build -t twblg .
docker run --rm twblg cat index.json > index.json
docker run --rm twblg cat dict-twblg.json > dict-twblg.json
```
#### 安裝docker
- 安裝 [docker](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
- 安裝 [docker-compose](https://docs.docker.com/compose/install/)
- 設定docker權限（Ubuntu）：`sudo usermod -aG docker $USER`
