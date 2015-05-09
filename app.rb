require "rack"

require_relative "lifx/light"
require_relative "lifx/controller"

require_relative "request_handler"

require_relative "action/brightness"
require_relative "action/color"
require_relative "action/off"
require_relative "action/on"
require_relative "action/render_file"
require_relative "action/root"

puts File.expand_path(File.dirname(__FILE__))
class App
  def initialize
    @lifx = Lifx::Controller.new
  end

  def call(env)
    request = Rack::Request.new(env)
    handler = RequestHandler.new(request, controller: @lifx)
    handler.respond
  end
end
