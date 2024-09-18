cask "superproductivity" do
  arch arm: "-arm64"

  version "10.0.7"
  sha256 arm:   "35218cf5173e3917a653e5bcdac5a8dc6ac7cbbb326469e9b0697f94316b4dd4",
         intel: "6519527af7e08e1bd2282c489f130c34142f150ab41058945450a725e20e66c5"

  url "https:github.comjohannesjosuper-productivityreleasesdownloadv#{version}superProductivity-#{version}#{arch}.dmg",
      verified: "github.comjohannesjosuper-productivity"
  name "Super Productivity"
  desc "To-do list and time tracker"
  homepage "https:super-productivity.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "superProductivity.app"

  zap trash: [
    "~LibraryApplication SupportsuperProductivity",
    "~LibraryLogssuperProductivity",
    "~LibraryPreferencescom.super-productivity.app.plist",
    "~LibrarySaved Application Statecom.super-productivity.app.savedState",
  ]
end