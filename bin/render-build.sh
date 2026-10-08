#!/usr/bin/env bash
# exit on error
set -o errexit

# Node.js 17+ の OpenSSL 互換性エラー防止
export NODE_OPTIONS=--openssl-legacy-provider

# パッケージのインストール
bundle install
yarn install --check-files

# アセットコンパイルとマイグレーション
SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
