cask "super-productivity" do
  arch arm: "arm64", intel: "x64"

  version "13.1.5"
  sha256 arm:   "b44143099b71cc0a6710c2c41221bfce8871420e01d367202087f8b62ed5d2b4",
         intel: "5bb6c01905275bc0cf387f84f862242eb817fe6f80800a540a04918eca730a59"

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