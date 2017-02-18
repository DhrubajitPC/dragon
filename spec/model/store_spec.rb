require 'rails_helper'

RSpec.describe Store, type: :model do  
	it {should have_many(:versions)}
	it {should validate_presence_of(:key)}
end