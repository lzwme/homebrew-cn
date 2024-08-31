cask "shotcut" do
  version "24.08.29"
  sha256 "24c7da67038cc701bc921f899413e30762d84b36c39a6518b82caa983eba8466"

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