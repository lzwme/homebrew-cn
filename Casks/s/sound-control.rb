cask "sound-control" do
  version "3.1.1"
  sha256 "fe96c2450d78fd6c759f986c40b791d6e09849085773ff17d12f3dd2833a0c6e"

  url "https://s3.amazonaws.com/staticz.net/downloads/soundcontrol/SoundControl_#{version}.dmg",
      verified: "s3.amazonaws.com/staticz.net/downloads/soundcontrol/"
  name "Sound Control"
  desc "Per-app audio controls"
  homepage "https://staticz.com/soundcontrol/"

  livecheck do
    url "http://staticz.net/updates/soundcontrol.rss"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Sound Control.app"

  uninstall launchctl: [
              "com.static.soundsiphon.inputagent",
              "com.staticz.audio.soundsiphon.playeragent",
              "com.staticz.soundsiphon.bridgedaemon",
            ],
            quit:      "com.staticz.SoundControl"

  zap trash: [
    "/Library/Audio/Plug-Ins/HAL/_SoundSiphon.driver",
    "/Library/LaunchAgents/com.staticz.soundsiphon.inputagent.plist",
    "/Library/LaunchAgents/com.staticz.soundsiphon.playeragent.plist",
    "/Library/LaunchDaemons/com.staticz.soundsiphon.bridgedaemon.plist",
    "/Library/Preferences/Audio/Data/_SoundSiphon.driver",
    "~/Library/Application Support/com.staticz.SoundControl",
    "~/Library/Caches/com.staticz.SoundControl",
    "~/Library/Cookies/com.staticz.SoundControl.binarycookies",
    "~/Library/Cookies/com.staticz.SoundControl.binarycookies*",
    "~/Library/HTTPStorages/com.staticz.SoundControl.binarycookies",
    "~/Library/Preferences/com.staticz.SoundControl.plist",
    "~/Library/Preferences/com.staticz.soundsiphon.playeragent.plist",
  ]
end