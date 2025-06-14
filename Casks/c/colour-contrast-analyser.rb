cask "colour-contrast-analyser" do
  version "3.5.4"
  sha256 "726faf5687a088025cb0168739334539140904369ceba5f3cde5e2193a374eba"

  url "https:github.comThePacielloGroupCCAereleasesdownloadv#{version}CCA-#{version}.dmg",
      verified: "github.comThePacielloGroupCCAe"
  name "Colour Contrast Analyser"
  desc "Colour contrast checker"
  homepage "https:www.tpgi.comcolor-contrast-checker"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Colour Contrast Analyser.app"

  zap trash: [
    "~LibraryPreferencescom.electron.cca.plist",
    "~LibrarySaved Application Statecom.electron.cca.savedState",
  ]
end