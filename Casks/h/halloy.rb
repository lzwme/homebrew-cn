cask "halloy" do
  version "2024.8"
  sha256 "a3e7e2dff5d2159843b2fcface880dc70efc3d64634cf4319f83572393d50700"

  url "https:github.comsquidowlhalloyreleasesdownload#{version}halloy.dmg",
      verified: "github.comsquidowlhalloy"
  name "Halloy"
  desc "IRC client"
  homepage "https:halloy.squidowl.org"

  depends_on macos: ">= :big_sur"

  app "Halloy.app"

  zap trash: [
    "~LibraryApplication Supporthalloy",
    "~LibrarySaved Application Stateorg.squidowl.halloy.savedState",
  ]
end