cask "polypane" do
  arch arm: "-arm64"

  version "25.0.0"
  sha256 arm:   "dcecb4eb2d6375ac3f9e3212d88c348d9b5b6a646db8e70e448dec6ebc537b68",
         intel: "917ec5d48b99cd60c99ba5ecb6692e0b2916a5c9ca35413eb3f9c6876c91425b"

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