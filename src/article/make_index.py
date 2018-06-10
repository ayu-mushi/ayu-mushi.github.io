#!/usr/bin/env python
# -*- coding: utf-8 -*-

import lxml.html
import os
import glob
import datetime
from prettyprint import pp
from jinja2 import Template
import feedformatter
import argparse
import time

# build/article下の全てのhtmlファイルをリストとして取得
# → pubdateの無いものや、下書きのものを取り除く (下書きのものには、pubdateを指定しないようにした。)
# → pubdate順にソート
# → タイトル、説明、を抽出
# → madokoファイルあるいはmdファイルにする (テンプレートを利用)
# → 出力(標準出力で良い)

# 【使い方】
# $ python src/article/make_index.py > src/article/index.mdk

article_dir = "build/article/"
pdf_dir = "build/article/pdf/"

files = glob.glob(article_dir + "*.html")

def readContent(path):
  f = open(path)
  content = f.read()
  f.close()
  return content

def getid_maybe(filename, id0):
    dom = lxml.html.fromstring(readContent(filename))
    try:
        return dom.get_element_by_id(id0).text_content()
    except KeyError:
        return None

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
    doc["pubdate"] = str2date(getid_maybe(filename, "pubdate"))
    doc["title"] = getid_maybe(filename, "post-title")
    doc["description"] = get_metadata(filename, "description")
    doc["keywords"] = get_metadata(filename, "keywords")
    doc["isthere_pdf_of"] = isthere_pdf_of(filename)
    doc["pdf_versions_name"] = os.path.basename(pdf_versions_name(filename))
    ftitle, fext = os.path.splitext(os.path.basename(filename))
    doc["github_source"] = "https://github.com/ayu-mushi/ayu-mushi.github.io/blob/develop/src/article/" + ftitle + ".mdk"
    doc["update"] = str2date(getid_maybe(filename, "update"))
    return doc

def all_to_mdk(doc_list):
    index_template_mdk = u"""
Title : 記事一覧
Description : 記事一覧、目次です
Keyword: 目次, 記事一覧
Author: ayu-mushi
[INCLUDE="../mytheme/myprelude.mdk"]

{% for doc in doc_list %}
* [{{ doc.title }}]({{ doc.file_base }} "{{doc.title}}"){% if doc.description != "" %}
  : 説明: {{ doc.description }}{% endif %}{% if doc.keywords != "" %}
  : キーワード: {{doc.keywords}}{% endif %}
  : ソース: <{{doc.github_source}}>
  : 投稿日: {{doc.pubdate}}
  : 最終更新日: {{doc["update"]}}{% if doc.isthere_pdf_of %}
  : [pdf版](pdf/{{ doc.pdf_versions_name }} "{{doc.title}} pdf版"){% endif %}{% endfor %}
"""

    t = Template(index_template_mdk)
    print(t.render(doc_list=doc_list).encode("utf-8"))

# RSS Atom
def all_to_rss(doc_list):
    feed = feedformatter.Feed()
    feed.feed['title'] = "title"
    feed.feed['link'] = "https://ayu-mushi.github.io/"
    feed.feed['author'] = "ayu-mushi"
    feed.feed['description'] = "ayu-mushi"
    feed.feed['pubDate'] = time.localtime()
    for doc in doc_list:
        feed.items.append({'title': doc["title"],
                           'description': doc["description"]
            })
    print(feed.format_atom_string())

def drafts():
    files = filter(lambda filename: getid_maybe(filename, "pubdate") is None, files)
    detailed_files = map(doc_detail, files)
    all_to_mdk(detailed_files)

files = filter(lambda filename: getid_maybe(filename, "pubdate") is not None, files)
detailed_files = map(doc_detail, files)
detailed_files = sorted(detailed_files, key=lambda file0: file0["pubdate"], reverse=True)

parser = argparse.ArgumentParser(description='generate index and rss')
subparsers = parser.add_subparsers()

ixCmd = subparsers.add_parser("index", help="index")
ixCmd.set_defaults(func=(lambda args: all_to_mdk(detailed_files)))

rssCmd = subparsers.add_parser("rss", help="rss")
rssCmd.set_defaults(func=(lambda args: all_to_rss(detailed_files)))

args = parser.parse_args()
args.func(args)
