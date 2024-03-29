require 'twilio-ruby'   

module TwilioMessage

	extend self

	def send_message(name, teacher, time, phone_number)
		account_sid = 'ACb13450bab258e762b6e3eb2f0aad33cb' 
		auth_token = '48ef7f7e8628fcc1869e36b816a997bf' 
 
		@client = Twilio::REST::Client.new account_sid, auth_token 
		@client.account.messages.create({ :body => "Hey #{name} you have an appointment at #{time} with #{teacher}",
			:from => '+17478004717', 
			:to => phone_number
		})
	end

end