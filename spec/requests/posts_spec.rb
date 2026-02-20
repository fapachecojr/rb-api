require "rails_helper"

RSpec.describe "Posts API", type: :request do
  it "cria e lista posts" do
    post "/api/v1/posts",
         params: { post: { title: "Teste", body: "Body" } },
         as: :json

	puts response.status
	puts response.body

    expect(response).to have_http_status(:created)

    get "/api/v1/posts"
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)
    expect(json).to be_a(Array)
    expect(json.first["title"]).to be_present
  end
end