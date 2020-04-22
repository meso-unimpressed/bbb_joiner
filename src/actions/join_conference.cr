require "openssl"
require "http"
require "../action"
require "./concerns/not_found"
require "./concerns/csrf"
require "./concerns/cache"

module BBBJoiner::Actions
  struct JoinConference
    include Action
    include Concerns::NotFound
    include Concerns::CSRF
    include Concerns::Cache

    def call(context, params)
      id = params["id"]
      link_request = get_link(id)
      return handle_not_found(context, id) if link_request.nil?

      body = context.request.body.try(&.gets_to_end) || ""
      form = HTTP::Params.parse(body)

      raise "Invalid CSRF token" unless valid_csrf?(form["csrf_token"]?)

      query_params = build_query_params(link_request, form)

      context.response.status = HTTP::Status::FOUND
      context.response.headers["Location"] = "#{BBBJoiner.config.bbb_url}/join?#{query_params}"
    end

    private def build_query_params(link_request, form)
      params = HTTP::Params::Builder.new

      params.add("meetingID", link_request.meeting_id)
      params.add("fullName", form["name"])
      params.add("password", link_request.password)
      params.add("redirect", "true")
      params.add("joinViaHtml5", "true")

      checksum = OpenSSL::SHA1.hash("join#{params}#{BBBJoiner.config.bbb_secret}").to_slice.hexstring
      params.add("checksum", checksum)

      params.to_s
    end
  end
end
