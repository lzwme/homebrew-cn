cask "background-music" do
  version "0.4.3"
  sha256 "c1c48a37c83af44ce50bee68879856c96b2f6c97360ce461b1c7d653515be7fd"

  url "https:github.comkyleneideckBackgroundMusicreleasesdownloadv#{version}BackgroundMusic-#{version}.pkg"
  name "Background Music"
  desc "Audio utility"
  homepage "https:github.comkyleneideckBackgroundMusic"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  pkg "BackgroundMusic-#{version}.pkg"

  uninstall_postflight do
    system_command "usrbinkillall",
                   args:         ["coreaudiod"],
                   sudo:         true,
                   must_succeed: true
  end

  uninstall launchctl: "com.bearisdriving.BGM.XPCHelper",
            quit:      "com.bearisdriving.BGM.App",
            pkgutil:   "com.bearisdriving.BGM",
            delete:    [
              "LibraryApplication SupportBackground Music",
              "LibraryAudioPlug-InsHALBackground Music Device.driver",
              "usrlocallibexecBGMXPCHelper.xpc",
            ]

  zap trash: [
    "LibraryLaunchDaemonscom.bearisdriving.BGM.XPCHelper.plist",
    "~LibraryPreferencescom.bearisdriving.BGM.App.plist",
  ]
end