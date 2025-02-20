cask "polypane" do
  arch arm: "-arm64"

  version "23.1.1"
  sha256 arm:   "671205ffad81ba4c5742e4de79445a37a910eb2efcdaa444cb061a9389f2e7e4",
         intel: "b0531a9cba38739da5d391df3b08ce30e65923ecf92792318d6acf99ccb7bf9c"

  url "https:github.comfirstversionistpolypanereleasesdownloadv#{version}Polypane-#{version}#{arch}.dmg",
      verified: "github.comfirstversionistpolypane"
  name "Polypane"
  desc "Browser for ambitious developers"
  homepage "https:polypane.app"

  depends_on macos: ">= :big_sur"

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