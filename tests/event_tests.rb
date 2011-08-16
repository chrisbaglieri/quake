require 'minitest/autorun'
Dir[File.join('../lib/quake', '*.rb')].each { |lib| require lib }

class EventTests < MiniTest::Unit::TestCase
  
  def test_recent_events_week
    events = Quake::Event.last_week
    assert(events.count > 0)
  end
  
  def test_recent_events_day
    events = Quake::Event.last_day
    assert(events.count > 0)
  end
  
  def test_recent_events_hour
    events = Quake::Event.last_hour
    assert(events.count > 0)
  end
  
  def test_recent_events_week_with_magnitude_of_two
    events = Quake::Event.last_week(4)
    events.each { assert(events[0].magnitude > 4) }
  end
  
  def test_recent_events_day_with_magnitude_of_two
    events = Quake::Event.last_day(2)
    events.each { assert(events[0].magnitude > 2) }
  end
  
  def test_recent_events_hour_with_magnitude_of_two
    events = Quake::Event.last_hour(1)
    events.each { assert(events[0].magnitude > 1) }
  end
  
end