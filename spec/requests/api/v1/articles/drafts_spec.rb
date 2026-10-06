require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let!(:old_draft) { create(:article, :draft, user: current_user, updated_at: 1.day.ago) }
    let!(:newest_draft) { create(:article, :draft, user: current_user) }

    before do
      create(:article, :published, user: current_user)
      create(:article, :draft)
    end

    it "自分が作成した下書き記事の一覧のみを取得できる（更新順）" do
      subject
      res = JSON.parse(response.body)
      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(res.length).to eq(2)
        expect(res.map {|d| d["id"] }).to eq [newest_draft.id, old_draft.id]
      end
    end
  end

  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "指定した id の記事が存在し、自分の下書き記事である場合" do
      let(:article) { create(:article, :draft, user: current_user) }
      let(:article_id) { article.id }

      it "指定した下書き記事の詳細が取得できる" do
        subject
        res = JSON.parse(response.body)
        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(res).to include("id" => article.id, "title" => article.title, "body" => article.body, "status" => "draft")
        end
      end
    end

    context "指定した id の記事が他人の下書き記事である場合" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, :draft, user: other_user) }
      let(:article_id) { article.id }

      it "記事が見つからない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
