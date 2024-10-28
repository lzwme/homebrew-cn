cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.28.1"
  sha256 arm:   "ed41fb80d2131ba6020e929b7d80a3d791173e8623f09fe1ac2b100b91647d69",
         intel: "a3e797bdb482eddc9a559236c3e17af7dc2f54eb0f88908fc54394e573c000c8"

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