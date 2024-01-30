cask "shotcut" do
  version "24.01.28"
  sha256 "d01464113c2f7fb4a6c31c023eac49cf6418d212481975c752912a2f3e558009"

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