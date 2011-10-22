A little wrapper script to tweet stuff automatically. It will handle retrying Twitter.update in case
Twitter is down, and it will exit 0 or 1 in case of success or failure. Errors are shown on stderr, making
it compatible with cron.

### EXAMPLE USAGE

    require 'twitterbot'
    require 'open-uri'
    require 'hpricot'
    require 'sanitize'

    # you must configure the twitter gem with your creds
    Twitter.configure do |config|
      config.consumer_key = 'key'
      config.consumer_secret = 'secret'
      config.oauth_token = 'token'
      config.oauth_token_secret = 'token-secret'
    end

    # run the twitterbot - it will exit 0 if successful
    Twitterbot.run do
      # return the text you want to tweet from this block. it will be trimmed to 140 chars for you
      quote = (Hpricot(open("http://thugbot.net/lebowski/"))/"blockquote").first
      Sanitize.clean(quote.inner_html).strip.gsub("\n",'')
    end


There are a few options you can pass to control the retry interval and whether or not to exit:

    text = Twitterbot.run(:max_attempts => 2, :sleep_time => 15, :do_not_exit => true) do
      'Aloha, Mr. Hand!'
    end
    puts %{I just tweeted "#{text}".}

When you run the twitterbot as a cron script, make sure you have cron email set to deliver to yourself. If
successful, you won't hear a peep. If it fails, you'll get the error (stderr) emailed to you.

    MAILTO=you@example.com
    15 10 * * *    /opt/ruby/bin/ruby /home/you/your_bot.rb > /dev/null
