module Action
  class Brightness
    include RequestHandler.handle("/brightness")

    def run
      controller.brightness(params["level"].to_i / 100.0)
      success
    end
  end
end
