#!/usr/bin/env bash
# exit on error
set -o errexit

# パッケージのインストール
bundle install
yarn install --check-files

# アセットコンパイルとマイグレーション
SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
