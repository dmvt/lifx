module Action
  class Off
    include RequestHandler.handle("/off")

    def run
      controller.off
    end
  end
end
