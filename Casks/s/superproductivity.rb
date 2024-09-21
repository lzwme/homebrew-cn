cask "superproductivity" do
  arch arm: "-arm64"

  version "10.0.10"
  sha256 arm:   "6a90426e0f6a212aed2997846258bc292c1e5b85a364e17902b24bc448176885",
         intel: "ff784b3900367476cef7a363d0ff14d47dbab11c9d8d1e5871d3264bc006db4a"

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