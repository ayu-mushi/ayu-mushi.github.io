#!/bin/bash

echo "ページのファイル名(拡張子除く)は?"
read PAGENAME

FILE="./src/article/$PAGENAME.mdk"

RESULT=""

echo "ページのタイトルは?"
read TITLE

RESULT+="Title: $TITLE\n"

RESULT+="Pubdate: $(date "+%Y-%m-%d")\n"
RESULT+="Update: &date;\n"

echo "ページの説明は?"
read DESK
RESULT+="Description: $DESK\n"

echo "キーワードは?"
read KEY
RESULT+="Keywords: $KEY\n"

echo "下書き?(y/n)"
read IS_DRAFT

case $IS_DRAFT in
  [yY] ) RESULT+="Draft: True\n"
esac

echo "vimをすぐ開く?(y/n)"
read IS_VIM

printf "$RESULT" > $FILE

case $IS_VIM in
  [yY] ) vim $FILE;;
  * ) echo "$FILE is created.";;
esac
