cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "11.0.2"
  sha256 arm:   "e70579a95fb2e79d2b55dfcfdc2e97f1410df5da4648ba458c2b3dc373a93c46",
         intel: "a5a24dffe5b7eceb9be68a77a67177f2369e7a1760809c760cf9e56a9d9d7699"

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