cask "multipass" do
  version "1.15.1"
  sha256 "878dfb719a0f39e1481b32bdca43dabeac9b71904510a3601a9ac037e5514173"

  on_arm do
    postflight do
      File.symlink("LibraryApplication Supportcom.canonical.multipassResourcescompletionsbashmultipass",
                   "#{HOMEBREW_PREFIX}etcbash_completion.dmultipass")
    end
  end

  url "https:github.comcanonicalmultipassreleasesdownloadv#{version}multipass-#{version}+mac-Darwin.pkg"
  name "Multipass"
  desc "Orchestrates virtual Ubuntu instances"
  homepage "https:github.comcanonicalmultipass"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  pkg "multipass-#{version}+mac-Darwin.pkg"

  uninstall launchctl: "com.canonical.multipassd",
            pkgutil:   "com.canonical.multipass.*",
            delete:    [
              "#{HOMEBREW_PREFIX}etcbash_completion.dmultipass",
              "ApplicationsMultipass.app",
              "LibraryApplication Supportcom.canonical.multipass",
              "LibraryLogsMultipass",
              "usrlocalbinmultipass",
              "usrlocaletcbash_completion.dmultipass",
            ]

  zap trash: [
    "~LibraryApplication Supportcom.canonical.multipassGui",
    "~LibraryApplication Supportmultipass",
    "~LibraryApplication Supportmultipass-gui",
    "~LibraryLaunchAgentscom.canonical.multipass.gui.autostart.plist",
    "~LibraryPreferencesmultipass",
    "~LibrarySaved Application Statecom.canonical.multipassGui.savedState",
  ]
end