%w(uri rubygems httparty colored).each {|lib| require lib}

# Limits
MAX_RPP = 100 # The number of tweets to return per page, up to a max of 100.
MAX_PAGES = 15

# Los Angeles
lat = 40.757929
lng = -73.985506
radius = "30mi"

# A little monkey patching..
class Hash
  def to_query_string
    self.map{ |k,v| "#{k}=#{v}" }.sort.join("&")
  end
end

# GET Params for the Twitter API request
params = {
  :q => "taste",
  :geocode => [lat, lng, radius].join(","),
  :rpp => MAX_RPP
}

1.upto(MAX_PAGES) do |page|

  params[:page] = page
  url = "http://search.twitter.com/search.json?" + URI.escape(params.to_query_string)
  puts url
  puts "**************************************************************"
  
  response = HTTParty.get(url)
  response['results'].each do |tweet|
    if /(.*)(taste)(.*)/.match(tweet['text'])
      puts [$1, $2.red, $3].join("")
    end
  end
  puts "\n\n"
end