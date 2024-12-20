cask "polypane" do
  arch arm: "-arm64"

  version "22.1.0"
  sha256 arm:   "4aac966a36c073c2ada1440452958f6e655ea10f45e311d78747876b35c6f2ef",
         intel: "2682d3baadd03864253cd8aeafa2dbe5684078a1920c5faa4c593a91bc3cf7d1"

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