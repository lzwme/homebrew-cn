cask "multipass" do
  version "1.12.2"
  sha256 "c2994476746369935ff54258a2c764cb6e344f77f64cf09688d55a86245bcbf4"

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
    "~LibraryApplication Supportmultipass",
    "~LibraryApplication Supportmultipass-gui",
    "~LibraryLaunchAgentscom.canonical.multipass.gui.autostart.plist",
    "~LibraryPreferencesmultipass",
  ]
end