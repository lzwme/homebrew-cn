cask "phoenix-slides" do
  version "1.5.5"
  sha256 "b64a8cb4b689e04d41f45a8c27c455369250456ba7ae586b0169a17dd4a73878"

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