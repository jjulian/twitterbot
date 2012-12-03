#
# A working example.
#
require 'twitterbot'
require 'open-uri'
require 'hpricot'
require 'sanitize'

#
# You must first configure the twitter gem with your Read/Write creds
# https://dev.twitter.com/apps/new
#
Twitter.configure do |config|
  config.consumer_key       = 'Consumer key'
  config.consumer_secret    = 'Consumer secret'
  config.oauth_token        = 'Access token'
  config.oauth_token_secret = 'Access token secret'
end

text = Twitterbot.tweet do
  quote = (Hpricot(open("http://thugbot.net/lebowski/"))/"blockquote").first
  Sanitize.clean(quote.inner_html).strip.gsub("\n",'')
end
puts "tweeted: --> #{text} <-- #{text.length} chars"
