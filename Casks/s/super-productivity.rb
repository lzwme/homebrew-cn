cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "13.0.11"
  sha256 arm:   "a4e25ddbaa57dc43629e3bd947384781fce4a7e9a9c98a14f3aa7dc53147ca9b",
         intel: "b59a701507d2f6dd2b1f4ff9781f0ded4be971c58ad860de72078afa9674f63f"

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