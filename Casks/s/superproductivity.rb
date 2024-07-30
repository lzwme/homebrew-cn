cask "superproductivity" do
  arch arm: "-arm64"

  version "9.0.6"
  sha256 arm:   "87d2ffdc2738d39f4241cc2e27cc43e46401ddb725f9ba3f0c4c25f02247742e",
         intel: "5dd00e483cc01dabbb27eb67fb1f0acf03a7ead06fba618ef2a2fbaecfb33a6b"

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