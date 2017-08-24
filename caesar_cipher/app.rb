require 'sinatra'
require 'sinatra/reloader'

# initial
get '/' do
	message = 'Please, input your text to encrypt:'
	erb :index, :locals => {:message => message}
end

# process
post "/" do
	text = params[:text]
	shift = 5
	
	if text != ''
		message = "Your cipher text is:<br>" + "<b>" + caesar_cipher(text, shift) + "</b>"
	else
		message = %Q(<b>That's not a valid text!</b>)
	end
	
	erb :index, :locals => {:message => message}
end

# helpers
def search_hash(to_search, search_by, hash)
  result = ''
	
  hash.each do |key, value|
		if search_by == "key" and key == to_search
			result = value
			break
		elsif search_by == "value" and value == to_search
			result = key
			break
		end
  end
	
  return result 
end

def change_letter(char, shift, hash)
	hash_length = hash.length
	
	# get position of char searching by value
	pos = search_hash(char, "value", hash).to_i
	
	if pos > 0 
		# calculate (shift + position)
		pos_new = pos + shift

		if pos_new > hash_length
			pos = pos_new - hash_length
		else
		  pos = pos_new	
		end  	
		
		# get value from this position searching by key, checking the original case
		return search_hash(pos, "key", hash)
	else 
		return char
	end	
end

def check_case(char)
	return char.scan(/\b[A-Z]+\b/)[0] == char ? "U" : "l"
end	

def caesar_cipher(string, shift)
	hash_upcase = { 
				 1 => "A", 2	 => "B", 3 => "C", 4 => "D", 5 => "E", 6	=> "F", 7 => "G", 8 => "H",
          9 => "I", 10 =>	"J", 11 => "K", 12 => "L", 13 =>	"M", 14	=> "N", 15 => "O", 16 => "P",
         17 =>	"Q", 18	=> "R", 19 => "S", 20 => "T", 21 => "U", 22	=>"V", 23	=> "W", 24 => "X",
         25 =>	"Y", 26 => "Z"
	} 
	
	hash_lowcase = { 
				 1 => "a", 2	 => "b", 3 => "c", 4 => "d", 5 => "e", 6	=> "f", 7 => "g", 8 => "h",
          9 => "i", 10 =>	"j", 11 => "k", 12 => "l", 13 =>	"m", 14	=> "n", 15 => "o", 16 => "p",
         17 =>	"q", 18	=> "r", 19 => "s", 20 => "t", 21 => "u", 22	=>"v", 23	=> "w", 24 => "x",
         25 =>	"y", 26 => "z"
	}

	new_string = ''
	hash = {}
	
	# iterate over all chars of string	
	string.split("").each do |char|
		type_char = check_case(char)
	
		if type_char == "U"
			hash = hash_upcase
		else
			hash = hash_lowcase
		end
		
		new_string += change_letter(char, shift, hash)
		hash = {}
	end
	
	return new_string
end

# Test
#puts "What a string!"
#puts caesar_cipher("What a string!", 5) == "Bmfy f xywnsl!"
			 
