module Action
  class RenderFile
    include RequestHandler::Handler

    def run
      # TODO: Don't let this access the entire OS
      [File.read(".#{request.path}")]
    end
  end
end
