cask "phoenix-slides" do
  version "1.5.3"
  sha256 "cafe1c31d41adc6cb6f6fdb90ff925d574cb94d098d048046fe730f54e7d1f6e"

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