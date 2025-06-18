cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "13.1.0"
  sha256 arm:   "8789341f52ace2d03b8d524bb915768d7043278146073e307d43e55b0b4fdb76",
         intel: "690144ef6fd93387a2797e54a675fd951665eeb539ca5847d702ed318d7985fb"

  url "https:github.comjohannesjosuper-productivityreleasesdownloadv#{version}superProductivity-#{arch}.dmg",
      verified: "github.comjohannesjosuper-productivity"
  name "Super Productivity"
  desc "To-do list and time tracker"
  homepage "https:super-productivity.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Super Productivity.app"

  zap trash: [
    "~LibraryApplication SupportsuperProductivity",
    "~LibraryLogssuperProductivity",
    "~LibraryPreferencescom.super-productivity.app.plist",
    "~LibrarySaved Application Statecom.super-productivity.app.savedState",
  ]
end