cask "minecraft-server" do
  version "1.21.8,6bce4ef400e4efaa63a13d5e6f6b500be969ef81"
  sha256 "2349d9a8f0d4be2c40e7692890ef46a4b07015e7955b075460d02793be7fbbe7"

  url "https://launcher.mojang.com/v#{version.major}/objects/#{version.csv.second}/server.jar",
      verified: "launcher.mojang.com/"
  name "Minecraft Server"
  desc "Run a Minecraft multiplayer server"
  homepage "https://www.minecraft.net/en-us/"

  # The server download page (https://www.minecraft.net/en-us/download/server)
  # HTML does not contain version information or a download link, as they are
  # fetched using separate JavaScript requests.
  livecheck do
    url "https://net-secondary.web.minecraft-services.net/api/v1.0/download/latest"
    regex(%r{/objects/(\h+)/server\.jar}i)
    strategy :json do |json, regex|
      latest_version = json["result"]
      next unless latest_version

      # Only fetch the download links JSON if the upstream version is newer than
      # the current cask version
      next version if latest_version == version.csv.first

      links_content = Homebrew::Livecheck::Strategy.page_content(
        "https://net-secondary.web.minecraft-services.net/api/v1.0/download/links",
      )[:content]
      next latest_version if links_content.blank?

      links_json = Homebrew::Livecheck::Strategy::Json.parse_json(links_content)
      link_hash = nil
      links_json.dig("result", "links")&.each do |link|
        next if link["downloadType"] != "serverJar"

        match = link["downloadUrl"]&.match(regex)
        next if match.blank?

        link_hash = match[1]
        break
      end

      link_hash ? "#{latest_version},#{link_hash}" : latest_version
    end
  end

  container type: :naked

  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/minecraft-server.wrapper.sh"
  binary shimscript, target: "minecraft-server"

  config_dir = HOMEBREW_PREFIX.join("etc", "minecraft-server")

  preflight do
    FileUtils.mkdir_p config_dir

    File.write shimscript, <<~EOS
      #!/bin/sh
      cd '#{config_dir}' && \
        exec /usr/bin/java ${@:--Xms1024M -Xmx1024M} -jar '#{staged_path}/server.jar' nogui
    EOS
  end

  eula_file = config_dir.join("eula.txt")

  postflight do
    system_command shimscript
    File.write(eula_file, File.read(eula_file).sub("eula=false", "eula=TRUE"))
  end

  uninstall_preflight do
    FileUtils.rm(eula_file) if eula_file.exist?
  end

  zap trash: config_dir

  caveats do
    depends_on_java "16+"
    <<~EOS
      Configuration files are located in

        #{config_dir}
    EOS
  end
end