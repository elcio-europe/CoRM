class Email < ActiveRecord::Base
  attr_accessible :attach_content_type, :attach_file_name, :attach_file_size, :content, :object, :send_at, :to, :user_id, :account_id, :contact_id

def check
	if (!account_id.nil?)
		if (!contact_id.nil?)
			if(!WebmailConnection.first.type_event_id.nil?)
				if (!(object + content).nil?)
					return true
				end
				return false
			end
			return false
		end
		return false
	end
	return false
end
end