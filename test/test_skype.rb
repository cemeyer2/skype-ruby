require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestSkype < MiniTest::Test

  SKYPE_FROM = ENV["SKYPE_FROM"]
  SKYPE_TO   = ENV["SKYPE_TO"]

  def test_exec
    body = "hello exec"
    res = Skype.exec "MESSAGE #{SKYPE_TO} #{body}"
    assert res =~ /^(CHAT)?MESSAGE \d+ STATUS (SENT|SENDING)$/, "Skype API response error"
    res_id = res.scan(/(CHAT)?MESSAGE (\d+) STATUS (SENT|SENDING)$/)[0][1].to_i
    msg = Skype::Chat::Message.new res_id
    assert_equal msg.id, res_id
    assert_equal msg.body, body
    assert_equal msg.time.class, Time
    assert_equal msg.user, SKYPE_FROM
  end

  def test_message
    body = "hello hello"
    res = Skype.message SKYPE_TO, body
    assert res =~ /^(CHAT)?MESSAGE \d+ STATUS (SENT|SENDING)$/, "Skype API response error"
    res_id = res.scan(/(CHAT)?MESSAGE (\d+) STATUS (SENT|SENDING)$/)[0][1].to_i
    msg = Skype::Chat::Message.new res_id
    assert_equal msg.id, res_id
    assert_equal msg.body, body
    assert_equal msg.time.class, Time
    assert_equal msg.user, SKYPE_FROM
  end

  def test_message_escape
    body = "hello \"'$@&()^![]{};*?<>`\\ world"
    res = Skype.message SKYPE_TO, body
    assert res =~ /^(CHAT)?MESSAGE \d+ STATUS (SENT|SENDING)$/, "Skype API response error"
    res_id = res.scan(/(CHAT)?MESSAGE (\d+) STATUS (SENT|SENDING)$/)[0][1].to_i
    msg = Skype::Chat::Message.new res_id
    assert_equal msg.id, res_id
    assert_equal msg.body, body
    assert_equal msg.time.class, Time
    assert_equal msg.user, SKYPE_FROM
  end
end