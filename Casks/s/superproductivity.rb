cask "superproductivity" do
  arch arm: "-arm64"

  version "8.0.0"
  sha256 arm:   "50870d0e1eb247a6f18f328bc3934903f19c8cf7148cca95d70cafe73b36ebad",
         intel: "426f6597c9fed07c67a1ab09e2cb01e69cbea931f0f7cd94fa261418a22e2af9"

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