cask "superproductivity" do
  arch arm: "-arm64"

  version "10.0.6"
  sha256 arm:   "c92a1a5a51532a1612ffa4cf004a8f94b9255ee919daabe32cb6f316e2ac1ca7",
         intel: "29d30d374cfef4b7a7f46400c13d0994cafae3ba625915ac39fabe9d559309e0"

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