cask "polypane" do
  arch arm: "-arm64"

  version "19.0.2"
  sha256 arm:   "af0c3a0ff73f782f15bea2002924ab603d697db682c8fb5725db1674abcf937d",
         intel: "785f5d81a81fa7e695c9fb5317ce435e339e9855ace47de57c91897b6314b5cc"

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