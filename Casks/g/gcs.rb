cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.20.0"
  sha256 arm:   "5b11fc7a29a3084c4851391dd34daef001fa7ee02293f8fc96ad64c709bfddeb",
         intel: "d193b2f6e9ae76226289743927e6741d4b25f9f1561bcabba60a4bc741a838f6"

  url "https:github.comrichardwilkesgcsreleasesdownloadv#{version}gcs-#{version}-macos-#{arch}.dmg",
      verified: "github.comrichardwilkesgcs"
  name "gcs"
  desc "Character sheet editor for the GURPS Fourth Edition roleplaying game"
  homepage "https:gurpscharactersheet.com"

  app "GCS.app"

  zap trash: [
    "~LibraryLogsgcs.log",
    "~LibraryPreferencescom.trollworks.gcs.plist",
    "~LibraryPreferencesgcs.json",
    "~LibrarySaved Application Statecom.trollworks.gcs.savedState",
    "~GCS",
  ]
end