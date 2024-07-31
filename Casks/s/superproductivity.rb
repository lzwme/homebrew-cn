cask "superproductivity" do
  arch arm: "-arm64"

  version "9.0.7"
  sha256 arm:   "e119d9730505a802f15c6b335b527beacf14afe103d4232ee8940f402c3b1832",
         intel: "329a45a4886f3cb85144d725e3b8345d3d0aeaa7b88e5a045b1bb231cffc874a"

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