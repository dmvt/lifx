module Action
  class Color
    include RequestHandler.handle("/color")

    def run
      controller.set(
        :r => params["r"].to_i,
        :g => params["g"].to_i,
        :b => params["b"].to_i
      )
      success
    end
  end
end
