cask "background-music" do
  version "0.4.0"
  sha256 "f170957702c48f96c0fa9706b72f6d6048bcc87be393eb1d01289c20e1111325"

  url "https:github.comkyleneideckBackgroundMusicreleasesdownloadv#{version}BackgroundMusic-#{version}.pkg"
  name "Background Music"
  desc "Audio utility"
  homepage "https:github.comkyleneideckBackgroundMusic"

  livecheck do
    url :url
    strategy :github_latest
  end

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