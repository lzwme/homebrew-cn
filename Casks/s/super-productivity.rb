cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "12.0.2"
  sha256 arm:   "d9afb9b01e9ed8fca8f3fc0ae73c80ed79f7f5c24a3209abebb8f20e885e9605",
         intel: "490db237e034f673cd860e201e8ced3ddadd2265b792aa56b4cea654e42d3bda"

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