module Action
  class On
    include RequestHandler.handle("/on")

    def run
      controller.on
    end
  end
end
