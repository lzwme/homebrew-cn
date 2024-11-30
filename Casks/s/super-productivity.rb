cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "10.2.3"
  sha256 arm:   "3d9b0df54b533aa4bf075cee37db2fe2fe13e1fc878cd523341b19da22c95560",
         intel: "8d80fb5f7c37b1de2ff77547f1ad2e309670eaad6523e1610ece897ef08614de"

  url "https:github.comjohannesjosuper-productivityreleasesdownloadv#{version}superProductivity-#{arch}.dmg",
      verified: "github.comjohannesjosuper-productivity"
  name "Super Productivity"
  desc "To-do list and time tracker"
  homepage "https:super-productivity.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Super Productivity.app"

  zap trash: [
    "~LibraryApplication SupportsuperProductivity",
    "~LibraryLogssuperProductivity",
    "~LibraryPreferencescom.super-productivity.app.plist",
    "~LibrarySaved Application Statecom.super-productivity.app.savedState",
  ]
end