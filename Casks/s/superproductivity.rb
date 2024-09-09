cask "superproductivity" do
  arch arm: "-arm64"

  version "10.0.2"
  sha256 arm:   "64e06c3e34f19461ffdf3c85661138928f547f571458c03eb3d635c4f4b4c5fc",
         intel: "721fb0912317038699697f79a0d35b7833811ae15858d0f5f27214570694b06e"

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