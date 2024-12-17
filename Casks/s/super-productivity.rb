cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "11.0.0"
  sha256 arm:   "5d1ec8352c31fe919eb97864efa2c62ab0dbdd0c0e0564f63b0e879bd6e628f5",
         intel: "52af8886666323abdf6e96cc184a7cf14efcb85d520f4b3b9b99434fac32a1d9"

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