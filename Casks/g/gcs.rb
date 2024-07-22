cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.25.1"
  sha256 arm:   "49c9ff7de767c9ed4057d3a64e0c43edf2702051e21190cc8198762d6ce011e7",
         intel: "086c758893a6f7478e095cea53560d874b5509131f8f8e75c7fdb0247e2620f3"

  url "https:github.comrichardwilkesgcsreleasesdownloadv#{version}gcs-#{version}-macos-#{arch}.dmg",
      verified: "github.comrichardwilkesgcs"
  name "gcs"
  desc "Character sheet editor for the GURPS Fourth Edition roleplaying game"
  homepage "https:gurpscharactersheet.com"

  app "GCS.app"

  zap trash: [
    "~GCS",
    "~LibraryLogsgcs.log",
    "~LibraryPreferencescom.trollworks.gcs.plist",
    "~LibraryPreferencesgcs.json",
    "~LibrarySaved Application Statecom.trollworks.gcs.savedState",
  ]
end