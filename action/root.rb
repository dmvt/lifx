module Action
  class Root
    include RequestHandler.handle("/")

    def run
      [File.read("public/index.html")]
    end
  end
end
