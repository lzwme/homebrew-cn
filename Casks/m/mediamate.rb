cask "mediamate" do
  version "3.2.0,265"
  sha256 "247c3b21d842d8ee6e8919ae86847bf43806e98ffb5112c84c8a98c9752c5208"

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