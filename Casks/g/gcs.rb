cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.26.1"
  sha256 arm:   "67056fc5fc8a70671da419ddb1d2c0732f57070a4253948240aa3dafd82580e4",
         intel: "78831ceae5f52aaa0cb277574b2cdb64c8895eb77c60cfd15ed5c433e5a4ec9c"

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