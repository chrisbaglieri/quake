require 'csv'
require 'curl'

module Quake
  
  class Event
    attr_accessor :source
    attr_accessor :id
    attr_accessor :version
    attr_accessor :datetime
    attr_accessor :latitude
    attr_accessor :longitude
    attr_accessor :magnitude
    attr_accessor :depth
    attr_accessor :nst
    attr_accessor :region
    
    def self.last_week(minimum_magnitude=2.5)
      raw_items = CSV.parse(Curl::Easy.perform(WEEK).body_str)
      create_events(raw_items, minimum_magnitude)
    end
    
    def self.last_day(minimum_magnitude=0)
      raw_items = CSV.parse(Curl::Easy.perform(DAY).body_str)
      create_events(raw_items, minimum_magnitude)
    end
    
    def self.last_hour(minimum_magnitude=0)
      raw_items = CSV.parse(Curl::Easy.perform(HOUR).body_str)
      create_events(raw_items, minimum_magnitude)
    end
    
    def initialize(raw)
      self.source = raw[0]
      self.id = raw[1]
      self.version = raw[2].to_i
      self.datetime = DateTime.strptime(raw[3], fmt="%A, %B %d, %Y %H:%M:%S UTC")
      self.latitude = raw[4]
      self.longitude = raw[5]
      self.magnitude = raw[6].to_f
      self.depth = raw[7].to_f
      self.nst = raw[8].to_i
      self.region = raw[9]
    end
    
    private
    
    def self.create_events(raw_items, minimum_magnitude)
      raw_items.shift
      events = []
      raw_items.each do |raw_item|
        event = Event.new(raw_item)
        if event.magnitude > minimum_magnitude
          events << Event.new(raw_item)
        end
      end
      events
    end
    
    WEEK = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M2.5.txt"
    DAY = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs1day-M0.txt"
    HOUR = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs1hour-M0.txt"
    
  end
  
end