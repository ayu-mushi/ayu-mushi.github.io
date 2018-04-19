#!/bin/bash

echo "ページのファイル名(拡張子除く)は?"
read PAGENAME

FILE="./src/article/$PAGENAME.mdk"

touch $FILE

echo "ページのタイトルは?"
read TITLE

printf "Title: %s\n" "$TITLE" > $FILE

printf "Pubdate: %s\n" "$(date "+%Y-%m-%d")" >> $FILE
printf "Update: &date;\n" >> $FILE

echo "ページの説明は?"
read DESK
printf "Description: %s\n" "$DESK" >> $FILE

echo "キーワードは?"
read KEY
printf "Keywords: %s\n" "$KEY" >> $FILE

echo "下書き?(y/n)"
read IS_DRAFT

case $IS_DRAFT in
  [yY] ) printf "Draft: True\n" "$KEY" >> $FILE
esac

echo "vimをすぐ開く?(y/n)"
read IS_VIM

case $IS_VIM in
  [yY] ) vim $FILE;;
  * ) echo "$FILE is created.";;
esac
