#!/usr/bin/env python
# -*- coding: utf-8 -*-

import lxml.html
import os
import glob
import datetime
from prettyprint import pp
from jinja2 import Template

# build/article下の全てのhtmlファイルをリストとして取得
# → pubdateの無いものや、下書きのものを取り除く (下書きのものには、pubdateを指定しないようにした。)
# → pubdate順にソート
# → タイトル、説明、を抽出
# → madokoファイルあるいはmdファイルにする (テンプレートを利用)
# → 出力(標準出力で良い)

article_dir = "build/article/"
pdf_dir = "build/article/pdf/"

files = glob.glob(article_dir + "*.html")

def readContent(path):
  f = open(path)
  content = f.read()
  f.close()
  return content

def get_pubdate(filename):
    dom = lxml.html.fromstring(readContent(filename))
    try:
        return dom.get_element_by_id("pubdate").text_content()
    except KeyError:
        return None

def has_pubdate(filename):
    return get_pubdate(filename) is not None

# ref: https://cre8cre8.com/python/sort_string_date.htm
def str2date(d):
    tmp = datetime.datetime.strptime(d, '%Y-%m-%d')
    return datetime.date(tmp.year, tmp.month, tmp.day)

def get_metadata(filename, dataname):
    dom = lxml.html.fromstring(readContent(filename))
    if len(dom.xpath('//meta[@name="'+dataname+'"]/@content')) == 0:
        return ""
    else:
        return dom.xpath('//meta[@name="'+dataname+'"]/@content')[0]

def pdf_versions_name(filename):
    ftitle, fext = os.path.splitext(os.path.basename(filename))
    return pdf_dir + ftitle + ".pdf"

def isthere_pdf_of(filename):
    return os.path.exists(pdf_versions_name(filename))

def doc_detail(filename):
    dom = lxml.html.fromstring(readContent(filename))
    doc = {}
    doc["file"] = filename
    doc["file_base"] = os.path.basename(filename)
    doc["pubdate"] = str2date(get_pubdate(filename))
    doc["title"] = dom.findtext(".//title")
    doc["description"] = get_metadata(filename, "description")
    doc["keywords"] = get_metadata(filename, "keywords")
    doc["isthere_pdf_of"] = isthere_pdf_of(filename)
    doc["pdf_versions_name"] = pdf_versions_name(filename)
    return doc

def all_to_mdk(doc_list):
    index_template_mdk = u"""
Title : 記事一覧
Description : 記事一覧、目次です
Keyword: 目次, 記事一覧
Author: ayu-mushi
[INCLUDE="../mytheme/myprelude.mdk"]

{% for doc in doc_list %}
* {{doc.pubdate}} [{{ doc.title }}]({{ doc.file_base }}) {{ doc.description }} {{doc.keywords}}
{% endfor %}
"""

    t = Template(index_template_mdk)
    print(t.render(doc_list=doc_list).encode("utf-8"))

files = filter(has_pubdate, files)
detailed_files = map(doc_detail, files)
detailed_files = sorted(detailed_files, key=lambda file0: file0["pubdate"])
all_to_mdk(detailed_files)
