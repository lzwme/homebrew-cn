cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "13.0.10"
  sha256 arm:   "a8887d2ec6de078a70a99678f1c1309d6a855f28e507848e62155ce05e11c5a6",
         intel: "333cfcbca8f537671643666f3d853288b9cf7d3cb5e86e1ad1ce9404a372462f"

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