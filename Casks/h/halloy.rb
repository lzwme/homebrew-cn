cask "halloy" do
  version "2024.10"
  sha256 "af488f6cee9db2f7a018cd1ad3874301476e5b9691db0a2ab3339690ab2c0f1b"

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