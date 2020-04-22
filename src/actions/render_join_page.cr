require "../action"
require "./concerns/not_found"
require "./concerns/csrf"
require "./concerns/cache"
require "../views/join"

module BBBJoiner::Actions
  struct RenderJoinPage
    include Action
    include Concerns::NotFound
    include Concerns::CSRF
    include Concerns::Cache

    def call(context, params)
      id = params["id"]

      link = get_link(id)
      return handle_not_found(context, id) if link.nil?

      Views::Join.new(link, generate_csrf_token).to_s(context.response)
    end
  end
end
