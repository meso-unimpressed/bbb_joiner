require "../view"
require "../models/link_request"

module BBBJoiner::Views
  struct Join < View
    forward_missing_to @info

    private getter csrf_token : String

    def initialize(@info : Models::LinkRequest, @csrf_token)
    end

    template("join")
  end
end
