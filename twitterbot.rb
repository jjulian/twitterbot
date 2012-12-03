require 'twitter'
require 'hashie'

class Twitterbot

  # Requires a block that returns the text to tweet, which will be trimmed to 140 chars.
  def self.tweet(options={})
    text = yield
    text = text.slice(0..139)
    perform text, options
  end

  private

  # Tweet a status update, with built-in retry and sleep between tries.
  def self.perform(text, options={})
    attempts = 0
    begin
      attempts += 1
      Twitter.update(text) unless options[:dry_run]
      text
    rescue Twitter::Error::ServerError, 
           Twitter::Error::TooManyRequests, Twitter::Error::EnhanceYourCalm, Twitter::Error::RateLimited => e
      $stderr.puts e.inspect
      if attempts < (options[:max_attempts] || 3)
        sleep options[:sleep_time] || 60
        retry
      else
        $stderr.puts "failing for good. could not send tweet '#{text}'"
        raise
      end
    end
  end

end
