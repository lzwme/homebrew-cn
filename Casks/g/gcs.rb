cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.25.0"
  sha256 arm:   "0089c53af4c8af572ffc3d430c1b84ca6c8769c20832c8cbf92db5ee8018bfb8",
         intel: "6c648a65a606cadf1396bcbe7271116433df5e69bff7d3188249632774480452"

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