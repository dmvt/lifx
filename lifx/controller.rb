require "lifx"

module Lifx
  class Controller
    attr_reader :lights, :client
    attr_accessor :duration

    def initialize
      load_client!
      discover!
      self.duration = 1
    end

    def reload
      discover!
    end

    def off
      lights.each(&:off)
    end

    def on
      lights.each(&:on)
    end

    def set(r: nil, g: nil, b: nil, brightness: nil)
      args = {}
      args[:r] = r unless r.nil?
      args[:g] = g unless g.nil?
      args[:b] = b unless b.nil?
      args[:brightness] = brightness unless brightness.nil?

      lights.each { |light| light.set(args) }
    end

    def r(n, d: duration)
      all_lights(:r, n, d)
    end

    def g(n, d: duration)
      all_lights(:g, n, d)
    end

    def b(n, d: duration)
      all_lights(:b, n, d)
    end

    def brightness(n, d: duration)
      all_lights(:brightness, n, d)
    end

    private

    def all_lights(key, value, d)
      lights.each { |light| light.send(key, value, :duration => d) }
    end

    def discover!
      client.discover!
      @lights = client.lights.map { |light| Lifx::Light.new(light) }
    end

    def load_client!
      @client = LIFX::Client.lan
    end
  end
end
