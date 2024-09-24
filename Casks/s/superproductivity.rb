cask "superproductivity" do
  arch arm: "-arm64"

  version "10.0.11"
  sha256 arm:   "01b97a5a676a1a6dfdabeed731672238b0f90caf9d76e74253d4f493614d8de6",
         intel: "08cc3ac2dba7e24721f75af3889bbcf3fd64b9090bff4e4f40ad3dc81656e58d"

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