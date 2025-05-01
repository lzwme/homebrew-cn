cask "polypane" do
  arch arm: "-arm64"

  version "24.0.1"
  sha256 arm:   "c63d11a9c4eaa7d690a10c2a39aebba04945be7a01e406c4d5ca968a808315d9",
         intel: "28d9ff100fd40bc2992023f1673c8acb95d81467be4a323a771b5e0b3bd4c521"

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