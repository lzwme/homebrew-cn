cask "superproductivity" do
  arch arm: "-arm64"

  version "8.0.0"
  sha256 arm:   "7a20d2a2b31849b7f40fb12df6090ca8ad0880c47b064a869fda185af3543b56",
         intel: "70e1616da903267ce972fae8dd80c4696ac17653883bb0bf5b49f9e3b8f44776"

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