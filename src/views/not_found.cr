require "../view"

module BBBJoiner::Views
  struct NotFound < View
    def initialize(@id : String? = nil)
    end

    template("not_found")
  end
end
