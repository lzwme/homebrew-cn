cask "sound-control" do
  version "3.2.2"
  sha256 "70a6ac69fb2e3127a01149b270676f973c1bfcf449f187374417201ede244c45"

  url "https://s3.amazonaws.com/staticz.net/downloads/soundcontrol/SoundControl_#{version}.dmg",
      verified: "s3.amazonaws.com/staticz.net/downloads/soundcontrol/"
  name "Sound Control"
  desc "Per-app audio controls"
  homepage "https://staticz.com/soundcontrol/"

  livecheck do
    url :homepage
    regex(/Sound\s+Control\s+v?(\d+(?:\.\d+)+)\s+Release\s+Notes/im)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0] }
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

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