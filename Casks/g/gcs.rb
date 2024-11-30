cask "gcs" do
  arch arm: "apple", intel: "intel"

  version "5.29.0"
  sha256 arm:   "2788c7e0614b61ecec77ac1e48409d293ff169cf05bd676588156eeef225ae9c",
         intel: "f7376cf30d512fa3c537525453fc14935ed541e29f07f987fd55a70a4e6851c4"

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