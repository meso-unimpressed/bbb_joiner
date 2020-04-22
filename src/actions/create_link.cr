require "http/status"
require "../action"
require "./concerns/cache"

module BBBJoiner::Actions
  struct CreateLink
    include Action
    include Concerns::Cache

    def call(context, params)
      return handle_unauthorized(context) unless context.authorized?
      body = context.request.body
      return handle_missing_body(context) if body.nil?
      link_request = Models::LinkRequest.from_json(body)

      loop do
        id = create_link(link_request)
        context.response.status = HTTP::Status::CREATED
        context.response.headers["Content-Type"] = "application/json"
        return {id: id}.to_json(context.response)
      end
    end

    private def handle_missing_body(context)
      context.response.status = HTTP::Status::BAD_REQUEST
      {error: "Missing or empty request body"}.to_json(context.response)
    end

    private def handle_unauthorized(context)
      context.response.status = HTTP::Status::UNAUTHORIZED
      {error: "Unauthorized"}.to_json(context.response)
    end
  end
end
