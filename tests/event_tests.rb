require 'minitest/autorun'
Dir[File.join('../lib/quake', '*.rb')].each { |lib| require lib }

class EventTests < MiniTest::Unit::TestCase
  
  def test_recent_events_day
    events = Quake::Event.last_day
    assert(events.count > 0)
  end
  
  def test_recent_events_hour
    events = Quake::Event.last_hour
    assert(events.count > 0)
  end
  
end