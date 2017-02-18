class VersionService

	def get_versioned_item(params)
		item = Store.find_by(key: params[:key])
		if item
			if params[:timestamp]
				time = Time.at(params[:timestamp].to_i).to_datetime
				versions = item.versions
				filtered_versions = versions.where("created_at <= ?", time)
				if filtered_versions.empty?
					{response: {errors: 'No such key before given timestamp'}, status: 422}
				else
					sorted_versions = filtered_versions.order(created_at: :desc)
					{response: sorted_versions.first.value.to_json, status: 200}
				end
			else
				{response: item.value.to_json, status: 200}
			end
		else
			{response: {errors: 'No such Key'}, status: 422}
		end
	end

	def create_versioned_item(params)
		existing_item = Store.find_by(key: params[:key])
		if existing_item
			if existing_item.update(params)
				create_version(existing_item)
				{response: existing_item, status: 200}
			else
				{response: {errors: existing_item.errors}, status: 422}
			end
		else
			item = Store.new(params)
			if item.save
				create_version(item)
				{response: item, status: 201}
			else
				{response: {errors: item.errors}, status: 422}
			end
		end
	end

	private
	def create_version(item)
		Version.create({store_id: item.id, value: item.value})
	end

end

