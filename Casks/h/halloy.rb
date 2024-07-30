cask "halloy" do
  version "2024.9"
  sha256 "f0cbf8c2dd2caf990b9795735d05ef5d975bf334fe2e2aab34a1980cc442cbe3"

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