module Lifx
  class Light
    DD = 1

    def initialize(light)
      self.light = light
      self.color = light.color
      self.level = color.brightness
      self.red, self.green, self.blue =
        hs_to_rgb(*(light.color.to_a[0..1]))
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

    def hs_to_rgb(h, s, v = 1)
      puts "HUE: #{h}"
      puts "SAT: #{s}"
      h = h.to_f
      s = s.to_f
      v = v.to_f

      if s == 0
        r = g = b = v
      else
        h = h / 60
        i = h.floor
        f = h - i
        p = v * (1 - s)
        q = v * (1 - s * f)
        t = v * (1 - s * (1 - f))

        puts "i: #{i}"
        case i
        when 0 then
          puts "case 0"
          r, g, b = v, t, p
        when 1 then
          puts "case 1"
          r, g, b = q, v, p
        when 2 then
          puts "case 2"
          r, g, b = p, v, t
        when 3 then
          puts "case 3"
          r, g, b = p, q, v
        when 4 then
          puts "case 4"
          r, g, b = t, p, v
        else
          puts "else"
          r, g, b = v, p, q
        end
      end

      return r * 255.0, g * 255.0, b * 255.0
    end
  end
end
