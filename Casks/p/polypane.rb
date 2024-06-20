cask "polypane" do
  arch arm: "-arm64"

  version "20.0.0"
  sha256 arm:   "4219424e0fa1c7395054e857acb0ad2bc4a25053fc175dfcddfba1e4c7fd88f6",
         intel: "b16583355e9593b4a7784be5cc5a889cdd0e6140b4229a474f25c2158d9095fb"

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