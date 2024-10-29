cask "polypane" do
  arch arm: "-arm64"

  version "22.0.0"
  sha256 arm:   "9b8de799c340b620a21d66887050bad10c79031d773e48287439566ec074b2ac",
         intel: "163c887e399ae1a0037ad024419fc76900af5058f50870e3c04b03daa4026726"

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