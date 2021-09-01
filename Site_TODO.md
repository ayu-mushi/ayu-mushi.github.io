#ayu-mushi.github.ioのTODO


##マークアップ言語の候補
* Madoko ✓
* pandocのmarkdown
* multimarkdown
* Scholdoc


##記事一覧
* madokoとmarkdownとの記事が混在するなら、一覧生成ではhtmlの側から記事情報を取るべき
* 公開日と最終更新日は別にした方がいい。なぜならソートするときに、最終更新日だけだと、一覧がへんになるから
* 公開日→手動記入、最終更新日→自動
* htmlから記事情報を取得: meta description, published date, updated date, title
* 公開日を表すPublished Dateというメタデータを使う
* 投稿一覧(article/index.html)自体は、投稿一覧に含まれないようにしないと。日付が書いてないやつは投稿一覧にふくめない…として、投稿一覧には日付を書かなければオッケーかな
* その場合、日付が書かれていないmadokoファイルは日付を出力しないようにしておく必要あり
* カテゴリ別とかタグ別とか 静的に生成
* 記事一覧でpdfはどうする?
* Draft は 日付が 消えるようにして、収集されなくしてある


##その他
* 記事を一覧するページを生成 (article/index.html)
* Newer Article Older Article (次、新しい、)
* Article、Game(Work)、Aboutといったものをサイドなどに表示
* \<meta name="twitter:title" content="About me"\>
* \<meta name="keywords" content=""\>
* \<meta name="twitter:site" content="mushi\_ayumu"\>
* \<meta name="description"\> madokoではHtml Meta で指定可能
* タイトルを見出しにすると、目次に含まれてしまう。
* article/pdf ?
* RSS
* madokoでtextlintはつかえないから、html側でやるかなー
* 設定ファイルが変更されると最終更新日がすべて同じになっちゃうのは避けなければならない →手動でいっか
* pdfでcaptionを使うと日本語がダメ。おそらく、XeLaTeX側の問題だろう →違う、XeLaTeX生成時に一部日本語をその前のコマンドとつながった奇形児みたいにしちゃうっぽい
* XeLaTeX、フォントがないから、太字がダメっぽい
* ルビ
* Proof環境の見出しはTheorem環境のより小さく表示した方がいい
* Google Analysis
* 伸縮する数学書 https://i3vi3.github.io/elastic-text/ac.html
* 索引自動生成 現在ページ数取得か、いまいる上の見出しを取得するか
  * 文書の構造化
* 「◯◯に関するメモ」みたいな感じで自由に書ける環境を用意したい
* 公開日記はどうか?
* 目次を横に出す
* Githubにある記事のソースへのリンクを自動で貼る
* MadokoのReferenceに使用されている、コードとその結果を両方表示するサンプル構文は、replaceで``` source ``` <hr> source のようにすれば良いっぽい
* 見出しのidが全部sectionになるのは見出しが英語じゃないのがまずい 解決策としては、設定で番号をidに含めるようにする id用に英語名を入れるとか
* 表示したり隠したりできるメニュー
* header-baseを変えれば、タイトルをh1とかh2にしてもオッケーだ しかし、#や##でなくhtml直書きにしないと、baseに相対的に決まるので、目次に含まれてしまう
* Theorem, Reference, Contentsなどを日本語にする場合、グローバルマッチじゃなくて先端マッチにすれば良い
* 横に出す目次はクリック(ホバー)すると展開するみたいな
* strong em b どうするか 赤文字 太字 傍点 隔字体 は日本語でも使えるが、斜体はへんになる
* <main>を~ ~に囲わず置くとダメだが、HtmlOnlyなどで囲うと良い
* 参考文献に注釈(コメント)付けられないか
* サイトに凡例をつけると良いのではないか
* サイトは、凡例に色々な言い換え、言い方などを書こうか
* これをGithubにあげる
* 自分用 index ―― Draft も 見えるページを 作るとか
* クリックで見出しなどを折りたたむ
* CCでライセンスを設定
* draftは別ブランチにしたほうがいいのでは？

##解決済み
* サブタイトルも付けたい
* なぜか更新してないのまでなっちゃうナンデ
* 説明Descriptionが無いと表示がおかしくなる make_indexの改行調整により解決
