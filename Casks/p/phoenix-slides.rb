cask "phoenix-slides" do
  version "1.5.6"
  sha256 "665680822f8cb6ca45e56336aadde29c77693868e568740c10952ab069ed16aa"

  url "https:github.comgobbledegookcreeveyreleasesdownloadv#{version}phoenix-slides-#{version.no_dots}.dmg",
      verified: "github.comgobbledegookcreevey"
  name "Phoenix Slides"
  desc "Full-screen slideshow program"
  homepage "https:blyt.netphxslides"

  depends_on macos: ">= :high_sierra"

  app "Phoenix Slides.app"

  zap trash: [
    "~LibraryCachescom.apple.helpdGeneratedPhoenix Slides Help*",
    "~LibraryPreferencesnet.blyt.phoenixslides.plist",
  ]
end