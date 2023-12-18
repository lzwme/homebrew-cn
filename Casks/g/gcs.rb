cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.18.0"
  sha256 arm:   "a30b9be95fcd3415d82533f5fb2a39aae8f7c725bb90acf32caf9a342a454ccb",
         intel: "bbf2d83e93019b63c037ddf062abf6bd3a1b5a71d259e9cf791fc05642cfde0a"

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