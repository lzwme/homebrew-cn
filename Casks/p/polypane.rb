cask "polypane" do
  arch arm: "-arm64"

  version "20.1.2"
  sha256 arm:   "b649caa6e1261754b03482e826303e65454529da28861b10599dd1714ca00bf5",
         intel: "bbb56c2c7c2464f1e77a0a42e8e430c53935f359544b52528687fbace14071b2"

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