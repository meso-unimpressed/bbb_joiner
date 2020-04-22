require "digest/md5"
require "baked_file_system"
require "http/server/handler"

module BBBJoiner::Handlers
  class StaticFiles
    include HTTP::Handler

    struct FileStorage
      extend BakedFileSystem

      bake_folder "#{__DIR__}/../../public"
    end

    class_getter manifest : Hash(String, String) = build_manifest

    private def self.build_manifest
      FileStorage.files.reduce(Hash(String, String).new) do |result, file|
        digest = Digest::MD5.new
        digest.update(file.to_slice)
        digest.final

        result[file.path.sub(%r|^/|, "")] = digest.result.to_slice.hexstring
        result
      end
    end

    def call(context : HTTP::Server::Context)
      file = FileStorage.get?(context.request.path.sub(BBBJoiner.config.root_path, ""))

      return call_next(context) if file.nil?
      context.response.content_type = MIME.from_filename?(file.path) || "application/octet-stream"
      context.response.headers["Cache-Control"] = "public, max-age=31536000"
      IO.copy(file, context.response)
    end
  end
end
