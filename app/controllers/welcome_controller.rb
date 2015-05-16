class WelcomeController < ActionController::Base

def index
	@users = User.all
end

end