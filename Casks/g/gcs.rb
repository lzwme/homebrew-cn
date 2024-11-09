cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.28.2"
  sha256 arm:   "01a0159d395c2c83dc34da16c380a22bd4206022f983623ec9fc2cdf613952f3",
         intel: "e8f2fb10fe4f089c409bb6d4463087ca64b1216790d79aa08b83f516e80993c3"

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