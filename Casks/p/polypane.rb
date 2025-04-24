cask "polypane" do
  arch arm: "-arm64"

  version "24.0.0"
  sha256 arm:   "1951dc28278f403e07bcda0dfd0132a4ce1660da7abc9c0870d8f8d915350978",
         intel: "f43ac96da04fb16152b994ac2c77a0c645913ca03f074972164fa1b9995684e3"

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