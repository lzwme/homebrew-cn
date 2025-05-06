cask "polypane" do
  arch arm: "-arm64"

  version "24.0.2"
  sha256 arm:   "80e0642c55348b4212ee2f2886e9b6d74fd3d6732db8bfb1bfeb595e980a1eca",
         intel: "e6248b40f2f4ae672b3fbf81a20316ea406b9c1e1aa1f46d39417ec8a83f8184"

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