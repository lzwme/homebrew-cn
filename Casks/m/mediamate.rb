cask "mediamate" do
  version "3.1.3,259"
  sha256 "41eee6dc7dcb36c8a011cbbc4eac5e723a956c4940a62c75d05c1dc75175bd41"

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