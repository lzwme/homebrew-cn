cask "ableton-live-standard" do
  version "12.2.1"
  sha256 "4993b035edac2256bc5d20c3aacf29fcbbe3a150d8a3b6e2555854d1b8d34092"

  url "https://cdn-downloads.ableton.com/channels/#{version}/ableton_live_standard_#{version}_universal.dmg"
  name "Ableton Live Standard"
  desc "Sound and music editor"
  homepage "https://www.ableton.com/en/live/"

  livecheck do
    cask "ableton-live-suite"
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Ableton Live #{version.major} Standard.app"

  uninstall quit: "com.ableton.live"

  zap trash: [
    "~/Library/Application Support/Ableton",
    "~/Library/Application Support/CrashReporter/Ableton *_*.plist",
    "~/Library/Application Support/CrashReporter/Live_*.plist",
    "~/Library/Caches/Ableton",
    "~/Library/Preferences/Ableton",
    "~/Library/Preferences/com.ableton.live.plist*",
    "~/Music/Ableton",
  ]
end