cask "polypane" do
  arch arm: "-arm64"

  version "17.0.0"
  sha256 arm:   "07b68dc9202d437c0747c79bfbf51c023426c6de4cd4e0aacd80b9ad96ebd921",
         intel: "07415347c2b55ce1f2ee7415598f39891bdc39899aca68f5f967e89f5e19f245"

  url "https:github.comfirstversionistpolypanereleasesdownloadv#{version}Polypane-#{version}#{arch}.dmg",
      verified: "github.comfirstversionistpolypane"
  name "Polypane"
  desc "Browser for ambitious developers"
  homepage "https:polypane.app"

  app "Polypane.app"

  zap trash: [
    "~LibraryApplication SupportPolypane",
    "~LibraryCachescom.firstversionist.polypane.ShipIt",
    "~LibraryCachescom.firstversionist.polypane",
    "~LibraryLogsPolypane",
    "~LibraryPreferencescom.firstversionist.polypane.plist",
    "~LibrarySaved Application Statecom.firstversionist.polypane.savedState",
  ]
end