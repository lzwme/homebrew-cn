cask "minecraft-server" do
  version "1.20.5,79493072f65e17243fd36a699c9a96b4381feb91"
  sha256 "f8f6a38fededc12d6bbac21e5341c168a7c9bf4ef90193fcf0abcc1366c42bac"

  url "https:launcher.mojang.comv#{version.major}objects#{version.csv.second}server.jar",
      verified: "launcher.mojang.com"
  name "Minecraft Server"
  desc "Run a Minecraft multiplayer server"
  homepage "https:www.minecraft.neten-us"

  livecheck do
    url "https:www.minecraft.neten-usdownloadserver"
    strategy :page_match do |page|
      page.scan(%r{href=.*?objects(\h+)server\.jar[^>]*>minecraft[_-]server[._-]v?(\d+(?:\.\d+)*)\.jar}i)
          .map { |match| "#{match[1]},#{match[0]}" }
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
    FileUtils.rm_f eula_file
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