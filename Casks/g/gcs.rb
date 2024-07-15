cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.24.0"
  sha256 arm:   "d250a69a611a60acb6666ac7df5a393234a34315113db0bea31f9d39fdb446bb",
         intel: "9067cb58b8be3ef59ed4f46309a2aeb1dc857128db9cbbe0b8623f5575c42402"

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