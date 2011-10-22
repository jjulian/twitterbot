require 'twitter'

class Twitterbot

  # Tweet a status update, with built-in retry and sleep between tries.
  def self.tweet(text, options={})
    attempts = 0
    begin
      attempts += 1
      send_tweet text unless options[:debug]
    rescue => e
      if attempts < (options[:max_attempts] || 3)
        sleep options[:sleep_time] || 60
        retry
      else
        puts "failing for good. could not send tweet '#{text}'"
        raise
      end
    end
  end
  
  def self.send_tweet(text)
    Twitter.update(text)
  end
  
  # Requires a block that returns the text to tweet, or raises if it cannot.
  def self.run(options={})
    begin
      text = yield
      text = text.slice(0..139)
      tweet text, options
      if options[:do_not_exit]
        text
      else
        exit 0
      end
    rescue => e
      if options[:do_not_exit]
        # I guess you'll handle it
        raise
      else
        # printing it out nice for you
        $stderr.puts e
        exit 1
      end
    end
  end
  
end