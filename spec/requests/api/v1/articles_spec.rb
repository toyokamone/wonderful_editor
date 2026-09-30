require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    let!(:old_article) { create(:article, updated_at: 1.day.ago) }
    let!(:older_article) { create(:article, updated_at: 2.days.ago) }
    let!(:newest_article) { create(:article) }

    it "記事の一覧が取得できる", :aggregate_failures do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq(3)
      expect(res.map {|d| d["id"] }).to eq [newest_article.id, old_article.id, older_article.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "指定した記事の詳細が取得できる", :aggregate_failures do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.slice("id", "title", "body")).to eq("id" => article.id, "title" => article.title, "body" => article.body)
        expect(res["updated_at"]).to be_present
        expect(res["user"]).to eq("id" => article.user.id, "name" => article.user.name, "email" => article.user.email)
      end
    end

    context "指定した id の記事が存在しない場合" do
      let(:article_id) { 10000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) do
      auth_headers = current_user.create_new_auth_token
      current_user.save!
      auth_headers
    end

    context "適切なパラメータを送信したとき" do
      let(:params) { { article: attributes_for(:article) } }

      it "記事が作成できる", :aggregate_failures do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq(params[:article][:title])
        expect(res["body"]).to eq(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) do
      auth_headers = current_user.create_new_auth_token
      current_user.save!
      auth_headers
    end

    context "自分が所持している記事のレコードを更新しようとするとき" do
      let(:article) { create(:article, user: current_user) }
      let(:params) { { article: { title: "更新後のタイトル", body: "更新後の本文" } } }

      it "記事を更新できる", :aggregate_failures do
        expect { subject }.to change { article.reload.title }.from(article.title).to("更新後のタイトル") &
                              change { article.reload.body }.from(article.body).to("更新後の本文")
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user) }
      let(:params) { { article: attributes_for(:article) } }

      it "更新できない（RecordNotFound）" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) do
      auth_headers = current_user.create_new_auth_token
      current_user.save!
      auth_headers
    end

    context "自分が所持している記事のレコードを削除しようとするとき" do
      let(:article) { create(:article, user: current_user) }
      before { article } # テスト開始前に事前作成させておく

      it "記事を削除できる", :aggregate_failures do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "自分が所持していない記事のレコードを削除しようとするとき" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user) }
      before { article } # テスト開始前に事前作成させておく

      it "削除できない（RecordNotFound）" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
