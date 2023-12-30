cask "superproductivity" do
  arch arm: "-arm64"

  version "7.17.1"
  sha256 arm:   "aa82b3835338a688ad307e7734faf4f5dc4a0b08916704aa070d41ef7f9f03ff",
         intel: "bde515b709db11ba953f63d20da1f140ab90e3061285077a3c0da2971d6cd156"

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