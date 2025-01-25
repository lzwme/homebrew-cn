cask "polypane" do
  arch arm: "-arm64"

  version "23.0.1"
  sha256 arm:   "cbd63d1959276eb81ba0cfe16c610789f239765b12e76ede5a775b958edc4107",
         intel: "ffd467249baa47e91c11aa9610e7ceaea25ac1452ed330a57358c0c3af19bcad"

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