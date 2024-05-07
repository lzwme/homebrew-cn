cask "colour-contrast-analyser" do
  version "3.5.3"
  sha256 "03ad0d71bfe68cc012cfbeb8034fec4ccc60f180af62a33df1c9e22f3956b1ac"

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