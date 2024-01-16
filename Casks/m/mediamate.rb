cask "mediamate" do
  version "3.0.0,235"
  sha256 "9b980c8716c9e5fb01b72b05e896ef9b2314367078fd7007a14cfbd61bc818dc"

  url "https:github.comWouter01MediaMate-Releasesreleasesdownloadv#{version.csv.first}_#{version.csv.second}MediaMate_v#{version.csv.first}-#{version.csv.second}.zip",
      verified: "github.comWouter01MediaMate-Releases"
  name "MediaMate"
  desc "UI replacement for volume, brightness and now playing controls"
  homepage "https:wouter01.github.ioMediaMate"

  livecheck do
    url "https:raw.githubusercontent.comWouter01MediaMate-Releasessparkleappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "MediaMate.app"

  uninstall quit: "com.tweety.MediaMate"

  zap trash: [
    "~LibraryCachesCloudKitcom.tweety.MediaMate",
    "~LibraryCachescom.tweety.MediaMate",
    "~LibraryHTTPStoragescom.tweety.MediaMate",
    "~LibraryHTTPStoragescom.tweety.MediaMate.binarycookies",
    "~LibraryPreferencescom.tweety.MediaMate.plist",
  ]
end