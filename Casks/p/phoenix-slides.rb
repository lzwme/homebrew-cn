cask "phoenix-slides" do
  version "1.5.7"
  sha256 "d761d9c34b44d1a5d7d9731ef27b83a2085d8293211d9b28ac7774e8bf6ef833"

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