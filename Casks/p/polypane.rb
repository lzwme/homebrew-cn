cask "polypane" do
  arch arm: "-arm64"

  version "18.0.4"
  sha256 arm:   "398fdb7ba1592c5ef880e3d8b8af8b8358b0961b7047127935e31d23e7bd7e22",
         intel: "64739ad6a3488c3e0600cd82e8419b33cd7df5dd51412a545e3c45e8bbb69f17"

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