cask "mediamate" do
  version "3.8.1,312"
  sha256 "30471d49286d785b7b5efc1bc36f1aacaeab07effc817c8f00160bb3b6821e0e"

  url "https://ghfast.top/https://github.com/Wouter01/MediaMate-Releases/releases/download/v#{version.csv.first}_#{version.csv.second}/MediaMate_v#{version.csv.first}-#{version.csv.second}.zip",
      verified: "github.com/Wouter01/MediaMate-Releases/"
  name "MediaMate"
  desc "UI replacement for volume, brightness and now playing controls"
  homepage "https://wouter01.github.io/MediaMate/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/Wouter01/MediaMate-Releases/sparkle/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "MediaMate.app"

  uninstall quit: "com.tweety.MediaMate"

  zap trash: [
    "~/Library/Caches/CloudKit/com.tweety.MediaMate",
    "~/Library/Caches/com.tweety.MediaMate",
    "~/Library/HTTPStorages/com.tweety.MediaMate",
    "~/Library/HTTPStorages/com.tweety.MediaMate.binarycookies",
    "~/Library/Preferences/com.tweety.MediaMate.plist",
  ]
end