cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.21.0"
  sha256 arm:   "f5e28c2acd013ba859b152e5cfa55fa5777925f429ecf3e75ae9e5e33a9f1bc4",
         intel: "cb2ec75ce245ae5e06eed76c88b6ea574834c5b1a3fe171dc1650b0ebe24d4cd"

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