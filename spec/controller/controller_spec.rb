require 'rails_helper'

RSpec.describe StoreController, type: :controller do

	describe 'GET #show' do
		before(:each) do 
			@p = { a:'v1' }
			post :create, @p.to_json 
			@t = DateTime.now.utc.to_i
			sleep 2
			@p2 = { a: 2145 }
			post :create, @p2.to_json
			@t2 = DateTime.now.utc.to_i
		end

		context 'without timestamp' do
			before(:each) do
				get :show, params: {key: 'a'}
			end
			it 'responds with the value of the key' do
				expect(response.body).to eql @p2[:a].to_s.to_json
			end
			it{ should respond_with 200 }
		end

		context 'with timestamp' do
			before(:each) do 
				get :show, params: {key: 'a', timestamp: (@t+1).to_s}
			end
			it 'responds with the new value of the key' do
				expect(response.body).to eql @p[:a].to_s.to_json
			end
			it{ should respond_with 200 }
		end

		context 'no object' do
			before(:each) do 
				get :show, params: {key: 'aloasdf'}
			end
			it 'responds with error' do
				resp = JSON.parse(response.body, symbolize_names: true)
				expect(resp).to have_key(:errors)
			end
			it{ should respond_with 422 }
		end
	end

	describe 'POST #create' do
		context 'new object' do
			before(:each) do
				@p = { b:'v1' }
				post :create, @p.to_json
			end
			it "returns the information about the object on a hash" do
				resp = JSON.parse(response.body, symbolize_names: true)
				expect(resp[:value]).to eql @p[:b]
			end
			it{expect(Store.all.count).to eql 1}
			it{expect(Version.all.count).to eql 1}
			it{should respond_with 201}
		end

		context 'existing object' do
			before(:each) do
				@p = { a:'v1' }
				post :create, @p.to_json 
				@p2 = { a: 2145 }
				post :create, @p2.to_json
			end
			it "returns the information about the object on a hash" do
				resp = JSON.parse(response.body, symbolize_names: true)
				expect(resp[:value]).to eql @p2[:a].to_s
			end
			it{expect(Store.all.count).to eql 1}
			it{expect(Version.all.count).to eql 2}
			it{should respond_with 200}
		end
	end

end