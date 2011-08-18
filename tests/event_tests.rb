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
  
  def test_recent_events_week_with_min_magnitude_of_three
    events = Quake::Event.last_week :min_magnitude => 3
    events.each { assert(events[0].magnitude >= 3) }
  end
  
  def test_recent_events_day_with_min_magnitude_of_two
    events = Quake::Event.last_day :min_magnitude => 2
    events.each { assert(events[0].magnitude >= 2) }
  end
  
  def test_recent_events_hour_with_min_magnitude_of_one
    events = Quake::Event.last_hour :min_magnitude => 1
    events.each { assert(events[0].magnitude >= 1) }
  end
  
  def test_recent_events_week_with_min_magnitude_of_three_max_magnitude_four
    events = Quake::Event.last_week :min_magnitude => 3, :max_magnitude => 4
    events.each do |event|
      assert(event.magnitude >= 3)
      assert(event.magnitude <= 4)
    end
  end
  
end