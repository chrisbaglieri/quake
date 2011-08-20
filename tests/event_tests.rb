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
  
  def test_recent_events_hour_with_bogus_criteria
    events = Quake::Event.last_hour :foo => 1
    assert(events.count > 0)
  end
  
  def test_event_distance_for_identicals
    events = Quake::Event.last_day
    event = events[0]
    assert(event.distance_from(event.latitude, event.longitude) == 0)
  end
  
  def test_event_distance_for_different
    events = Quake::Event.last_day
    event1 = events[0]
    event2 = events[events.count-1]
    assert(event1.distance_from(event2.latitude, event2.longitude) > 0)
  end
  
  def test_revent_events_with_epicenter
    events = Quake::Event.last_day
    event = events[0]
    events = Quake::Event.last_day :epicenter => "#{event.latitude},#{event.longitude}"
    assert(events.count == 1)
  end
  
  def test_revent_events_with_epicenter_and_distance
    events = Quake::Event.last_day
    event = events[0]
    events = Quake::Event.last_day :epicenter => "#{event.latitude},#{event.longitude}", :distance => 20004 # half the earth's circumference
    assert(events.count > 1)
  end
  
end