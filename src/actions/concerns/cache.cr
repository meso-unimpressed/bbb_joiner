require "../../models/link_request"

module BBBJoiner::Actions::Concerns
  module Cache
    private SAFE_CHARS = ('a'..'z').to_a + ('0'..'9').to_a

    def create_link(link_request)
      loop do
        id = SAFE_CHARS.sample(9, random: Random::Secure).each_slice(3).map(&.join).join('-')

        set_result = BBBJoiner.redis.set(
          key: id,
          value: link_request.to_json,
          ex: BBBJoiner.config.link_ttl,
          nx: true
        )

        return id unless set_result.nil?
      end
    end

    def get_link(id)
      BBBJoiner.redis.get(id).try { |json| Models::LinkRequest.from_json(json) }
    end
  end
end
