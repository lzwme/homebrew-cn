cask "phoenix-slides" do
  version "1.5.8"
  sha256 "bbf7b8c85ce5137fea85714c168ea02179b89537a78628d89c86e71840d6f26e"

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