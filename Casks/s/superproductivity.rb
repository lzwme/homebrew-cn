cask "superproductivity" do
  arch arm: "-arm64"

  version "8.0.7"
  sha256 arm:   "a7534d304acb4fabe46040cbe842edc35daad0df0a056547065e8a129fd7861f",
         intel: "3e3039626a753a056259467bf8a524ac111286a09e8f34d3b19d4042d49e353d"

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