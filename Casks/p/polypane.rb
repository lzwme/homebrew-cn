cask "polypane" do
  arch arm: "-arm64"

  version "22.1.1"
  sha256 arm:   "036810a1c75ec00ecf5feee821b6835107b5b91039f38ef79948a8aa4bb2d760",
         intel: "87477fd9863c6239c63e2ba1038bcdd66f7baaba9546c540f0d49df7dac7ecb3"

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