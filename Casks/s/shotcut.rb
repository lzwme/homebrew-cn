cask "shotcut" do
  version "24.04.28"
  sha256 "391f65eeeb72cdae16c41d88a334a842737c9d4d3356796762a72efd4cd9997d"

  url "https:github.commltframeworkshotcutreleasesdownloadv#{version}shotcut-macos-#{version.no_dots}.dmg",
      verified: "github.commltframeworkshotcut"
  name "Shotcut"
  desc "Video editor"
  homepage "https:www.shotcut.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Shotcut.app"

  zap trash: [
    "~LibraryApplication SupportMeltytech",
    "~LibraryCachesMeltytech",
    "~LibraryPreferencescom.meltytech.Shotcut.plist",
  ]
end