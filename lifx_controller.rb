require "lifx"

class LifxController
  attr_reader :lights
  attr_accessor :client, :duration

  def initialize(
    client: LIFX::Client.lan,
    r: 255,
    g: 255,
    b: 255,
    brightness: 0.5
  )
    self.client = client
    client.discover!
    self.lights = client.lights
    self.duration = 1
    set(r: r, g: g, b: b, brightness: brightness)
  end

  def lights=(lights)
    @lights = lights.map { |light|
      LifxController::Light.new(light)
    }
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

  class Light
    DD = 1

    def initialize(light)
      self.light = light
      self.color = light.color
      self.level = color.brightness
      self.red = 255
      self.green = 255
      self.blue = 255
    end

    def off
      light.turn_off
    end

    def on
      light.turn_on
    end

    def set(r: red, g: green, b: blue, brightness: level, duration: DD)
      @red, @green, @blue, @level = r, g, b, brightness
      @color = LIFX::Color.rgb(r, g, b)
      color.brightness = level
      light.set_color(color, :duration => duration)
    end

    def r(n, duration: DD)
      set(:r => n, duration: duration)
    end

    def g(n, duration: DD)
      set(:g => n, duration: duration)
    end

    def b(n, duration: DD)
      set(:b => n, duration: duration)
    end

    def brightness(n, duration: DD)
      set(:brightness => n, duration: duration)
    end

    private

    attr_accessor :level, :light, :red, :green, :blue, :color
  end
end

