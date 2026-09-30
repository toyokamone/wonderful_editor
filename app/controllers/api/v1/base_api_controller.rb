class Api::V1::BaseApiController < ApplicationController
  # devise_token_auth のヘルパー（current_user, authenticate_user!, user_signed_in?）を有効化
  include DeviseTokenAuth::Concerns::SetUserByToken

  # devise_token_auth が用意している current_api_v1_user を current_user として使えるようにエイリアスを定義
  alias_method :current_user, :current_api_v1_user
  alias_method :authenticate_user!, :authenticate_api_v1_user!
  alias_method :user_signed_in?, :api_v1_user_signed_in?
end
