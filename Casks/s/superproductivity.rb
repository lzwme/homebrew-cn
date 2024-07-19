cask "superproductivity" do
  arch arm: "-arm64"

  version "9.0.3"
  sha256 arm:   "6656c07222e1e57e4f9aabb2dcd6b1b2c316945538a7770709a349eab7da25df",
         intel: "94a2e81cf6aaeeeb4d85606671689c3fedec252f466fcc3f4ba899ab0a4db2fc"

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