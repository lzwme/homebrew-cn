cask "colour-contrast-analyser" do
  version "3.5.1"
  sha256 "1216e8e7e2b00940c0a6dd848ba9c5badacaa2408dc4a5433d9195c31f20630c"

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