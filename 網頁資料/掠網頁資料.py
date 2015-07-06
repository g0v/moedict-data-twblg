from bs4 import BeautifulSoup
from collections import OrderedDict
from csv import DictReader
import json
from os.path import join
from random import random
import re
from time import sleep
from urllib.request import urlopen


class 掠網頁資料:
    條目網址 = 'http://twblg.dict.edu.tw/holodict_new/result_detail.jsp?n_no={}&curpage=1&sample=%E5%AA%A0&radiobutton=1&querytarget=1&limit=20&pagenum=1&rowcount=9'
    
    def 異用字(self, 主編號):
        with urlopen(self.條目網址.format(主編號), timeout=10) as 網頁資料:
            網頁結構 = BeautifulSoup(網頁資料.read().decode('utf-8'), 'lxml')
            for 對應td文字 in 網頁結構(text=re.compile(r'異用字')):
                return 對應td文字.parent.findNext('td').get_text().strip()
        return ''

    def 全部編號(self):
        with open(join('..', 'pua', '詞目總檔.csv')) as 檔:
            讀檔 = DictReader(檔)
            for row in 讀檔:
                yield row['主編碼']

if __name__ == '__main__':
    全部資料 = OrderedDict()
    網頁資料 = 掠網頁資料()
    for 主編號 in 網頁資料.全部編號():
        異用字 = 網頁資料.異用字(主編號)
        if 異用字:
            全部資料[主編號] = 異用字.split('、')
        sleep(random())
    with open(join('..', 'x-異用字.json'), 'wt') as 結果檔案:
        json.dump(全部資料, 結果檔案, indent=2, ensure_ascii=False)
