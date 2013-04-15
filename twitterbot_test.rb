require 'test/unit'
require 'mocha/setup'
require 'twitterbot'

class TwitterbotTest < Test::Unit::TestCase
  def setup
    Twitter.stubs(:update)
  end
  def test_returns_the_tweet
    text = "My snarky comment."
    result = Twitterbot.tweet { text }
    assert result == text, "should return the tweet text"
  end
  def test_raises_if_no_text
    assert_raises(ArgumentError) { result = Twitterbot.tweet { nil } }
  end
  def test_trims_text_at_140_chars
    text = 'X' * 200
    result = Twitterbot.tweet { text }
    assert result.size == 140
  end
  def test_fails_if_error
    Twitter.stubs(:update).raises(Twitter::Error::RateLimited)
    assert_raises(Twitter::Error::RateLimited) { Twitterbot.tweet(sleep_time: 0.01) { "My thoughts." } }
  end
end