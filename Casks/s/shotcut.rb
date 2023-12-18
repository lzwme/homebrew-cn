cask "shotcut" do
  version "23.12.15"
  sha256 "08914e936b06e7f4c9ce71cbf0ec154c7dd08e7d0963c5f46bcfef60ae4a9713"

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