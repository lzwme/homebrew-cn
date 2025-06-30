cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "14.0.0"
  sha256 arm:   "94455cd35ce83256930aaf05920a5ffd13ee4834c21b4d12092788e10f1c0f55",
         intel: "1604bc49182a1b0a833a53ee51e8942ffe7271e6cec56b31bdd6982e4af79f33"

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