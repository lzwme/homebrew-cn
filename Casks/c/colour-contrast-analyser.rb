cask "colour-contrast-analyser" do
  version "3.5.2"
  sha256 "719a077c5280fe39c6496a69de13bc9a51a1c2d6d3537a89b84c5daeaaa09c1b"

  url "https:github.comThePacielloGroupCCAereleasesdownloadv#{version}CCA-#{version}.dmg",
      verified: "github.comThePacielloGroupCCAe"
  name "Colour Contrast Analyser"
  desc "Colour contrast checker"
  homepage "https:www.tpgi.comcolor-contrast-checker"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Colour Contrast Analyser.app"

  zap trash: [
    "~LibraryPreferencescom.electron.cca.plist",
    "~LibrarySaved Application Statecom.electron.cca.savedState",
  ]
end