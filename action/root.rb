module Action
  class Root
    include RequestHandler.handle("/")

    def run
      [File.read("index.html")]
    end
  end
end
