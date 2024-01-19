cask "polypane" do
  arch arm: "-arm64"

  version "17.1.0"
  sha256 arm:   "cca482ed990dbec3d6cc763ec4392cf5dc563defde720d4be037467d19c3c33e",
         intel: "0f4954c67279ac0c2e008107f15374589d83e503eacae1b83ebacfaa03b27977"

  url "https:github.comfirstversionistpolypanereleasesdownloadv#{version}Polypane-#{version}#{arch}.dmg",
      verified: "github.comfirstversionistpolypane"
  name "Polypane"
  desc "Browser for ambitious developers"
  homepage "https:polypane.app"

  app "Polypane.app"

  zap trash: [
    "~LibraryApplication SupportPolypane",
    "~LibraryCachescom.firstversionist.polypane.ShipIt",
    "~LibraryCachescom.firstversionist.polypane",
    "~LibraryLogsPolypane",
    "~LibraryPreferencescom.firstversionist.polypane.plist",
    "~LibrarySaved Application Statecom.firstversionist.polypane.savedState",
  ]
end