require 'spec_helper'

describe SearchController, "for admins" do

  before(:each) do
    #session[:user_id] = FactoryGirl.create(:admin).id
    sign_in FactoryGirl.create(:admin)

    FactoryGirl.create(:domain, :name => 'example.com')
    FactoryGirl.create(:domain, :name => 'example.net')
  end

  it "should return results when searched legally" do
    get :results, :q => 'exa'

    expect(assigns(:results)).not_to be_nil
    expect(response).to render_template('search/results')
  end

  it "should handle whitespace in the query" do
    get :results, :q => ' exa '

    expect(assigns(:results)).not_to be_nil
    expect(response).to render_template('results')
  end

  it "should redirect to the index page when nothing has been searched for" do
    get :results, :q => ''

    expect(response).to be_redirect
    expect(response).to redirect_to( root_path )
  end

  it "should redirect to the domain page if only one result is found" do
    domain = FactoryGirl.create(:domain, :name => 'slave-example.com')

    get :results, :q => 'slave-example.com'

    expect(response).to be_redirect
    expect(response).to redirect_to( domain_path( domain ) )
  end

end

describe SearchController, "for api clients" do
  before(:each) do
    sign_in(FactoryGirl.create(:api_client))

    FactoryGirl.create(:domain, :name => 'example.com')
    FactoryGirl.create(:domain, :name => 'example.net')
  end

  it "should return an empty JSON response for no results" do
    get :results, :q => 'amazon', :format => 'json'

    expect(assigns(:results)).to be_empty

    expect(response.body).to eq("[]")
  end

  it "should return a JSON set of results" do
    get :results, :q => 'example', :format => 'json'

    expect(assigns(:results)).not_to be_empty

    json = ActiveSupport::JSON.decode( response.body )
    expect(json.size).to be(2)
    expect(json.first["domain"].keys).to include('id', 'name')
    expect(json.first["domain"]["name"]).to match(/example/)
    expect(json.first["domain"]["id"].to_s).to match(/\d+/)
  end
end
