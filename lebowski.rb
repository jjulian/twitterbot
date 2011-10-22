#
# A working usage example.
#

require 'open-uri'
require 'hpricot'
require 'sanitize'
require 'twitterbot'

text = Twitterbot.run(:do_not_exit => true, :debug => true) do
  quote = (Hpricot(open("http://thugbot.net/lebowski/"))/"blockquote").first
  Sanitize.clean(quote.inner_html).strip.gsub("\n",'')
end
puts text