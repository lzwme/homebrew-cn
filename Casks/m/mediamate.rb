cask "mediamate" do
  version "3.0.4,243"
  sha256 "d570882886845e02c4ea656959ebff8433d30e37001d644680be9c703c2d5f30"

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