#!/bin/bash
find raw/ -name '*csv' -exec grep [$'\x02'$'\x0e'] -H {} \; | grep -v ':0$'
val=$?
if [ $val -eq 0 ]; then
  echo "面頂的檔案有控制字元！！"
  exit 1
elif [ $val -eq 1 ]; then
  echo "檔案攏無問題～～"
  exit 0
else
  echo "發生錯誤"
  exit 2
fi
