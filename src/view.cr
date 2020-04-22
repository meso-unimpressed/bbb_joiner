require "ecr"
require "./handlers/static_files"

module BBBJoiner
  abstract struct View
    def static_asset(path)
      "./#{path}?#{Handlers::StaticFiles.manifest[path]}"
    end

    macro template(name)
      ECR.def_to_s({{ "#{__DIR__}/templates/#{name.id}.ecr" }})
    end
  end
end
