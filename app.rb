require "rack"
require_relative "./lifx_controller"

class App
  def initialize
    @controller = LifxController.new
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path == "/color"
      @controller.set(
        :r => req.params["r"].to_i,
        :g => req.params["g"].to_i,
        :b => req.params["b"].to_i
      )
      [200, {}, ["Success!"]]
    elsif req.path == "/brightness"
      @controller.brightness(req.params["level"].to_i / 100.0)
      [200, {}, ["Success!"]]
    elsif req.path == "/off"
      @controller.off
      [200, {}, ["Success!"]]
    elsif req.path == "/on"
      @controller.on
      [200, {}, ["Success!"]]
    elsif req.path == "/"
      [200, {}, [File.read("index.html")]]
    else
      [200, {}, [File.read(".#{req.path}")]]
    end
  end
end
