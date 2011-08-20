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
    
    def self.last_week(criteria = {:min_magnitude => 2.5})
      raw_items = CSV.parse(Curl::Easy.perform(WEEK).body_str)
      create_events(raw_items, criteria)
    end
    
    def self.last_day(criteria = {})
      raw_items = CSV.parse(Curl::Easy.perform(DAY).body_str)
      create_events(raw_items, criteria)
    end
    
    def self.last_hour(criteria = {})
      raw_items = CSV.parse(Curl::Easy.perform(HOUR).body_str)
      create_events(raw_items, criteria)
    end
    
    def distance_from(lat, long)
      (Math.acos(Math.sin(self.latitude) * 
      Math.sin(lat) + Math.cos(self.latitude) * 
      Math.cos(lat) * Math.cos(self.longitude - long)) * 
      SPHERICAL_APPROX_OF_EARTH).round(2)
    end
    
    def initialize(raw)
      self.source = raw[0]
      self.id = raw[1]
      self.version = raw[2].to_i
      self.datetime = DateTime.strptime(raw[3], fmt="%A, %B %d, %Y %H:%M:%S UTC")
      self.latitude = raw[4].to_f
      self.longitude = raw[5].to_f
      self.magnitude = raw[6].to_f
      self.depth = raw[7].to_f
      self.nst = raw[8].to_i
      self.region = raw[9]
    end
    
    private
    
    def self.create_events(raw_items, criteria)
      criteria[:max_magnitude] = 10 unless criteria[:max_magnitude]
      raw_items.shift
      events = []
      raw_items.each do |raw_item|
        event = Event.new(raw_item)
        valid_event = true
        criteria.keys.each do |criterion|
          case criterion
          when :min_magnitude
            valid_event = false unless event.magnitude >= criteria[criterion]
          when :max_magnitude
            valid_event = false unless event.magnitude <= criteria[criterion]
          when :epicenter
            criteria[:distance] = 0 unless criteria[:distance]
            valid_event = self.check_distance(event, criteria)
          end
        end
        events << Event.new(raw_item) if valid_event
      end
      events
    end
    
    def self.check_distance(event, criteria)
      valid_event = true
      if LAT_LONG_REGEX.match(criteria[:epicenter])
        coordinates = criteria[:epicenter].split(',').collect{ |coordinate| coordinate.strip.to_f }
        valid_event = false unless event.distance_from(coordinates[0], coordinates[1]) <= criteria[:distance]
      else
        valid_event = false
      end
      valid_event
    end
        
    WEEK = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M2.5.txt"
    DAY = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs1day-M0.txt"
    HOUR = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs1hour-M0.txt"
    SPHERICAL_APPROX_OF_EARTH = 6371 # km
    LAT_LONG_REGEX = /^\s*[-+]?\d+\.\d+\,\s?[-+]?\d+\.\d+\s*$/
    
  end
  
end