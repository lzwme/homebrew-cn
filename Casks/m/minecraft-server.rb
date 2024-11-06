cask "minecraft-server" do
  version "1.21.3,45810d238246d90e811d896f87b14695b7fb6839"
  sha256 "e153b89b02c0839cdf5e8c1d57c80dd42a3fffb80c60817632080c041bf8afb5"

  url "https:launcher.mojang.comv#{version.major}objects#{version.csv.second}server.jar",
      verified: "launcher.mojang.com"
  name "Minecraft Server"
  desc "Run a Minecraft multiplayer server"
  homepage "https:www.minecraft.neten-us"

  livecheck do
    url "https:www.minecraft.neten-usdownloadserver"
    regex(%r{href=.*?objects(\h+)server\.jar[^>]*>minecraft[_-]server[._-]v?(\d+(?:\.\d+)*)\.jar}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[1]},#{match[0]}" }
    end
  end

  container type: :naked

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}minecraft-server.wrapper.sh"
  binary shimscript, target: "minecraft-server"

  config_dir = HOMEBREW_PREFIX.join("etc", "minecraft-server")

  preflight do
    FileUtils.mkdir_p config_dir

    File.write shimscript, <<~EOS
      #!binsh
      cd '#{config_dir}' && \
        exec usrbinjava ${@:--Xms1024M -Xmx1024M} -jar '#{staged_path}server.jar' nogui
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