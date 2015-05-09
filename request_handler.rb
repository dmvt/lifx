require "pipe"

class RequestHandler
  NotImplemented = Class.new(StandardError)
  ROUTES = {}

  attr_accessor :request, :controller, :body, :error

  def initialize(request, controller:)
    self.request = request
    self.controller = controller
  end

  def error?
    error
  end

  def respond
    response = Response.new(:body => route)
    response.status = 400 if error?
    response.to_a
  end

  def route
    self.body =
      ROUTES
        .fetch(request.path, Action::RenderFile)
        .new(controller: controller, request: request)
        .run
  rescue => e
    ["#{e.class.name}: #{e.message} \n#{e.backtrace.join('\n')}"]
  end

  class Response
    attr_accessor :body, :headers, :status

    def initialize(body: [], headers: {}, status: 200)
      self.body = body
      self.headers = headers
      self.status = status
    end

    def to_a
      [status, headers, body]
    end
  end

  module Handler
    def initialize(controller:, request:)
      self.controller = controller
      self.request = request
    end

    def params
      request.params
    end

    def run(*args)
      raise NotImplemented, "#{self.class} must implement #run"
    end

    def success
      ["Success!"]
    end

    private

    attr_accessor :controller, :request
  end

  def self.handle(path = nil)
    Module.new do
      define_singleton_method :included do |descendant|
        ROUTES[path] = descendant if path
        descendant.send(:include, Pipe)
        descendant.send(:include, Handler)
      end
    end
  end
end
