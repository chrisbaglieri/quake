require 'csv'
require 'curl'

module Quake
  
  class Event
    attr_accessor :source
    attr_accessor :id
    attr_accessor :version
    attr_accessor :date
    attr_accessor :latitude
    attr_accessor :longitude
    attr_accessor :magnitude
    attr_accessor :depth
    attr_accessor :nst
    attr_accessor :region
    
    def self.last_day
      raw_items = CSV.parse(Curl::Easy.perform(DAY).body_str)
      create_events(raw_items)
    end
    
    def self.last_hour
      raw_items = CSV.parse(Curl::Easy.perform(HOUR).body_str)
      create_events(raw_items)
    end
    
    def initialize(raw)
      self.source = raw[0]
      self.id = raw[1]
      self.version = raw[2]
      self.date = raw[3]
      self.latitude = raw[4]
      self.longitude = raw[5]
      self.magnitude = raw[6]
      self.depth = raw[7]
      self.nst = raw[8]
      self.region = raw[9]
    end
    
    private
    
    def self.create_events(raw_items)
      raw_items.shift
      events = []
      raw_items.each do |raw_item|
        events << Event.new(raw_item)
      end
      events
    end
    
    DAY = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs1day-M0.txt"
    HOUR = "http://earthquake.usgs.gov/earthquakes/catalogs/eqs1hour-M0.txt"
    
  end
  
end