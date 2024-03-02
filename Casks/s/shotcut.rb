cask "shotcut" do
  version "24.02.29"
  sha256 "5cb0d10ce8a813d6a30c1ded50133bd02a560b7b98e9c52ebcb97beeaf2449db"

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