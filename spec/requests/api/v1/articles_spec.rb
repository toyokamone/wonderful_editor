require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    let!(:old_article) { create(:article, :published, updated_at: 1.day.ago) }
    let!(:older_article) { create(:article, :published, updated_at: 2.days.ago) }
    let!(:newest_article) { create(:article, :published) }
    let!(:draft_article) { create(:article, :draft) }

    it "公開されている記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      aggregate_failures do
        expect(res.length).to eq(3)
        expect(res.map {|d| d["id"] }).not_to include(draft_article.id)
        expect(res.map {|d| d["id"] }).to eq [newest_article.id, old_article.id, older_article.id]
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在し、公開状態である場合" do
      let(:article) { create(:article, :published) }
      let(:article_id) { article.id }

      it "指定した記事の詳細が取得できる" do
        subject
        res = JSON.parse(response.body)
        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(res).to include("id" => article.id, "title" => article.title, "body" => article.body, "status" => "published")
        end
      end
    end

    context "指定した id の記事が下書き状態である場合" do
      let(:article) { create(:article, :draft) }
      let(:article_id) { article.id }

      it "記事が見つからない（RecordNotFound）" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "指定した id の記事が存在しない場合" do
      let(:article_id) { 100_000_000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "status を draft（下書き）として送信したとき" do
      let(:params) { { article: attributes_for(:article, status: :draft) } }

      it "下書き記事が作成できる" do
        aggregate_failures do
          expect { subject }.to change { current_user.articles.count }.by(1)
          res = JSON.parse(response.body)
          expect(res["status"]).to eq("draft")
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "status を published（公開）として送信したとき" do
      let(:params) { { article: attributes_for(:article, status: :published) } }

      it "公開記事が作成できる" do
        aggregate_failures do
          expect { subject }.to change { current_user.articles.count }.by(1)
          res = JSON.parse(response.body)
          expect(res["status"]).to eq("published")
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
