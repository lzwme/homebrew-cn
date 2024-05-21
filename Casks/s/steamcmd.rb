cask "steamcmd" do
  version "1716242337"
  sha256 :no_check

  url "https:steamcdn-a.akamaihd.netclientinstallersteamcmd_osx.tar.gz",
      verified: "steamcdn-a.akamaihd.net"
  name "SteamCMD"
  desc "Command-line client for Steam"
  homepage "https:developer.valvesoftware.comwikiSteamCMD"

  livecheck do
    url "http:media.steampowered.comclientsteam_cmd_osx"
    regex("version"\s*"([^"]+)"i)
  end

  auto_updates true

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = staged_path"steamcmd.wrapper.sh"
  binary shimscript, target: "steamcmd"

  preflight do
    # Running for the first time will create a Frameworks symlink in the parent
    # directory pointing to a MacOS directory, so move the files in a MacOS directory.
    files = staged_path.glob("*")
    macos_dir = staged_path"MacOS"
    macos_dir.mkpath
    FileUtils.mv files, macos_dir

    shimscript.write <<~SH
      #!binsh
      exec '#{macos_dir}steamcmd.sh' "$@"
    SH
  end

  uninstall launchctl: "com.valvesoftware.steamclean"

  zap trash: "~LibraryApplication SupportSteamlogsstderr.txt",
      rmdir: [
        "~LibraryApplication SupportSteam",
        "~LibraryApplication SupportSteamlogs",
      ]
end