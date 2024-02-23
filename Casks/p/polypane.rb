cask "polypane" do
  arch arm: "-arm64"

  version "18.0.0"
  sha256 arm:   "0be0605716954ec155a90e45f5f9516d6a27decce179e14d00e17326df0f6123",
         intel: "4be1bdf3fce95f7ad9a282f849f6802dd1adf113dc92ab180b14d82dc5745bd7"

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