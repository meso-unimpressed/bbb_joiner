require "../action"
require "./concerns/not_found"

module BBBJoiner::Actions
  struct NotFound
    include Action
    include Concerns::NotFound

    def call(context, _params = nil)
      handle_not_found(context)
    end
  end
end
