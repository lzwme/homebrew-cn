cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "14.0.1"
  sha256 arm:   "ccd7a2211d4e33878e1196ece04a5349d79f61e1488b7a355af2f3200c1aca12",
         intel: "475d4442c2951b045fc5f118ddeb6dfea8f6260f16ed2836de29d6290af16447"

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