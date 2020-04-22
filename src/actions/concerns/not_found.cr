require "../../views/not_found"

module BBBJoiner::Actions::Concerns
  module NotFound
    private def handle_not_found(context, id = nil)
      context.response.status = HTTP::Status::NOT_FOUND
      context.response.headers["Content-Type"] = "text/html"
      Views::NotFound.new(id).to_s(context.response)
    end
  end
end
