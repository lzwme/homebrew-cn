cask "clamshell" do
  version "2.0.2,242"
  sha256 "6f89696c41d8369596a1a6ebd79526a0dd295e9f4ffdbe53948787f83bc1e8f0"

  url "https://clamshell.dev/Clamshell-#{version.csv.first}-#{version.csv.second}.dmg"
  name "Clamshell"
  desc "Keep the computer awake with the lid closed and the built-in display dark"
  homepage "https://clamshell.dev/"

  livecheck do
    url "https://clamshell.dev/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Clamshell.app"

  uninstall launchctl: "com.rathonyi.clamshell.agent",
            quit:      "com.rathonyi.clamshell"

  zap trash: [
    "~/Library/Application Support/Clamshell",
    "~/Library/Caches/com.rathonyi.clamshell",
    "~/Library/HTTPStorages/com.rathonyi.clamshell",
    "~/Library/Preferences/com.rathonyi.clamshell.plist",
  ]
end