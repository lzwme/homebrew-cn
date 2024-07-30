cask "polypane" do
  arch arm: "-arm64"

  version "20.1.1"
  sha256 arm:   "db9a0330c375cf526755317d7bd9ead727883c8e2d88edcb8bfeb017ae98fce9",
         intel: "b57fb8dabda16349e42f934a40098bd0660ef144e6fea46cb46da6c77f452bf8"

  url "https:github.comfirstversionistpolypanereleasesdownloadv#{version}Polypane-#{version}#{arch}.dmg",
      verified: "github.comfirstversionistpolypane"
  name "Polypane"
  desc "Browser for ambitious developers"
  homepage "https:polypane.app"

  app "Polypane.app"

  zap trash: [
    "~LibraryApplication SupportPolypane",
    "~LibraryCachescom.firstversionist.polypane",
    "~LibraryCachescom.firstversionist.polypane.ShipIt",
    "~LibraryLogsPolypane",
    "~LibraryPreferencescom.firstversionist.polypane.plist",
    "~LibrarySaved Application Statecom.firstversionist.polypane.savedState",
  ]
end