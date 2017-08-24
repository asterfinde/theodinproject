require 'sinatra'
require 'sinatra/reloader'

enable :sessions

# initial
get '/' do
	message = 'Do you want to play guessing <b>positive</b> numbers between 1 and 100?'
	session[:number] = rand(101)
	erb :index, :locals => {:message => message}
end

# process
post "/" do
	guess = params[:guess]
	
	if guess =~ /\A\d+\z/ ? true : false
		message = session[:number]
		message = check_guess(guess)
	else
		message = %Q("That's not a number!")
	end
	
	erb :index, :locals => {:message => message}
end

get '/logout' do
  session = {}
  redirect '/'
end

# helper
def check_guess(guess)	
	case 
		when session[:number].to_i > guess.to_i then "#{guess} is low than SECRET NUMBER" 
		when session[:number].to_i == guess.to_i then "You got it right! <b>#{guess}</b> is the SECRET NUMBER. <br>Click <a href='/logout'>here</a> to play again."
		when session[:number].to_i < guess.to_i then "#{guess} is high than SECRET NUMBER"
	end
end
	