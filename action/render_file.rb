module Action
  class RenderFile
    include RequestHandler::Handler

    def run
      [File.read("./public#{request.path}")]
    end
  end
end
