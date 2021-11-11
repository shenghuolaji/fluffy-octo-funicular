# herokuへのデプロイ方法

以下の手順でデプロイをおこなってください。

## heroku cliのインストール
以下を参考にheroku cliをインストールします。

[The Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

macの場合
```shell
brew tap heroku/brew && brew install heroku
```

## heroku login
以下のコマンドを実行してください。
ブラウザが開き、認証が行われます。
```shell
heroku login


## heroku アプリの作成
以下のコマンドを実行し、herokuにアプリを作成します。
(この時点では、まだアプリケーションはデプロイされません)
```shell
git init
heroku create {任意のアプリ名}
```
[heroku](https://dashboard.heroku.com/apps) にアクセスし、アプリが作成されていることを確認してください。

## アプリケーションのデプロイ

注意: 先にShopify partners上でカスタムアプリを作成しておく必要があります。

### デプロイ

コミットを作成しておきます。
```sh
git add .
git commit -m 'commit for push'
```

以下のコマンドを実行し、herokuアプリにアプリケーションをデプロイします。
```shell
git push heroku master
```

### 環境変数の設定

以下のコマンドを実行し、環境変数に認証情報を追加します。
```shell
heroku config:set SHOPIFY_API_KEY=6d90ed43f0b7100d168d5d74e1b843b9 SHOPIFY_API_SECRET=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
```
`{}`の値は、それぞれ以下を当てはめてください。
- `SHOPIFY_API_KEY`: Shopify partners > アプリ管理 > 作成したカスタムアプリ > APIキー > APIキー の値
- `SHOPIFY_API_SECRET`: Shopify partners > アプリ管理 > 作成したカスタムアプリ > APIキー > APIシークレットキーの値

### マイグレーション

以下のコマンドを実行し、アプリケーションに必要なテーブルをDB上に作成します。
```shell
heroku run rake db:migrate
```

## デプロイしたアプリケーションとShopifyのストアを紐づける
デプロイしたアプリケーションのURLに遷移して、(デフォルトでは `https://xxx.herokuapp.com/` のようなURLです)以下の画面が表示されることを確認します。
<img width="979" alt="Screenshot 2021-11-07 at 3 29 09" src="https://user-images.githubusercontent.com/31527437/140620115-df3c1885-c207-4635-9d1e-69bfa8135f32.png">

入力欄にインストール先ストアのドメインを入力し、「Install app」をクリックします。
