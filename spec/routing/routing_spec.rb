require 'rails_helper'

RSpec.describe StoreController, type: :routing do
	
	it { expect(get: '/object/:key').to route_to(controller: 'store', action: 'show', key: ':key') }
	it { expect(get: '/object/:key?timestamp=1487385125').to route_to(controller: 'store', action: 'show', key: ':key', timestamp: '1487385125') }
	it { expect(post: '/object/').to route_to(controller: 'store', action: 'create') }

end