cask "polypane" do
  arch arm: "-arm64"

  version "19.0.1"
  sha256 arm:   "a603fe401118d0fb3ed2dd8c7e3aa641ec27cbeb07836136b8795797e8f97af0",
         intel: "4b433ea880b8250864f62f058cc0568d8f58fdf8871c9c920d9e2353c4825434"

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