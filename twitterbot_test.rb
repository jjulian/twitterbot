require 'test/unit'
require 'mocha/setup'
require 'twitterbot'

class TwitterbotTest < Test::Unit::TestCase
  def setup
    super
    @orig_stderr = $stderr
    @orig_stdout = $stdout
    $stderr = $stdout = File.new('/dev/null', 'w')
  end

  def teardown
    $stderr = @orig_stderr
    $stdout = @orig_stdout
    @orig_stderr = @orig_stdout = nil
    super
  end

  def test_returns_the_tweet
    assert_silent do
      text = "My snarky comment."
      Twitter.expects(:update).with(text).once()
      result = Twitterbot.tweet { text }
      assert_equal(text, result, "should return the tweet text")
    end
  end
  def test_raises_if_no_text
    Twitter.expects(:update).never()
    assert_raises(ArgumentError) { result = Twitterbot.tweet { nil } }
  end
  def test_can_be_a_dry_run
    Twitter.expects(:update).never()
    text = 'Just testing'
    result = Twitterbot.tweet(dry_run: true) { text }
    assert_equal(text, result, "should return the tweet text")
  end
  def test_trims_text_at_140_chars
    text = 'X' * 200
    expected = text.slice(0,140)
    Twitter.expects(:update).with(expected).once()
    result = Twitterbot.tweet { text }
    assert_equal(140, result.size)
    assert_equal(expected, result, "should return the tweet text")
  end
  def test_fails_if_error
    ex = Twitter::Error::RateLimited
    out, err = capture_io do
      max = 5
      Twitter.expects(:update).at_least(max).raises(ex)
      assert_raises(ex) { Twitterbot.tweet(sleep_time: 0.01, max_attempts: max) { "My thoughts." } }
    end
    assert_empty out, 'nothing should be sent to stdout'
    refute_empty err, 'errors should be printed on stderr'
    assert_match(/#{ex.to_s}/, err)
  end
end