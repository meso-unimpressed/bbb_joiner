require "json"

module BBBJoiner::Models
  struct LinkRequest
    include JSON::Serializable

    getter meeting_id : String
    getter password : String
  end
end
