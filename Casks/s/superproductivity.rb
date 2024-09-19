cask "superproductivity" do
  arch arm: "-arm64"

  version "10.0.9"
  sha256 arm:   "b57fa8fd55574a3c680d8c2203cfa3f0d8cab2b8057fa506789d20244e167040",
         intel: "b3429a51d1b8ae26458efd51798175c4e4c775f1d6f7d74924b49050cf7d7b15"

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