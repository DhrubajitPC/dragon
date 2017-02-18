require 'rails_helper'

RSpec.describe StoreController, type: :controller do

	describe 'GET #show' do
		context 'without timestamp' do
			before(:each) do
				item = FactoryGirl.create(:store, key: "a", value: "a1")
				get :show, params: {key: item.key}
			end
			it 'responds with the value of the key' do
				expect(response.body).to eql item.value
			end
			it{ should respond_with 200 }
		end

		context 'with timestamp' do

		end

		context 'no object' do

		end

	end
end