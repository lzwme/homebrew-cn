cask "polypane" do
  arch arm: "-arm64"

  version "19.0.0"
  sha256 arm:   "80bd20f669f2db2c3618f408e89617ad28e1b65bc5e5e0fb03b02bb280d079eb",
         intel: "3ee48581a6777bef5d997994239b354859ca708c529894f223f305eb425a8d11"

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