cask "polypane" do
  arch arm: "-arm64"

  version "21.0.0"
  sha256 arm:   "860c53d5d0eb6aac2aff5261297b355efe51fed9df4bc1216a893236c7694250",
         intel: "123370dad7f2ceea3dbb975be0ce8914f0eea2a35deb156bc2217e62b2c0e94e"

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