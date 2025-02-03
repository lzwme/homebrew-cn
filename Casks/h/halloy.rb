cask "halloy" do
  version "2025.1"
  sha256 "90fb1c7c20c10ffc822aad37298be32d30e36c72cb477948b552481d2ca738f0"

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