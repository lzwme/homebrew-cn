cask "raze" do
  version "1.10.2"
  sha256 "c1892c20add48bbaabdae2af8bfb034f4e45cad118b791c65053fd738e9e6563"

  url "https:github.comcoelckersRazereleasesdownload#{version}raze-macos-#{version}.zip",
      verified: "github.comcoelckersRaze"
  name "Raze"
  desc "Build engine port backed by GZDoom tech"
  homepage "https:raze.zdoom.orgabout"

  livecheck do
    url "https:raze.zdoom.orgdownloads"
    regex(href=.*?raze[._-]macos[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  depends_on macos: ">= :catalina"

  app "Raze.app"

  zap trash: [
    "~DocumentsRaze",
    "~LibraryApplication SupportRaze",
    "~LibraryPreferencesorg.drdteam.raze.plist",
    "~LibraryPreferencesorg.zdoom.raze.plist",
    "~LibraryPreferencesraze.ini",
    "~LibrarySaved Application Stateorg.drdteam.raze.savedState",
    "~LibrarySaved Application Stateorg.zdoom.raze.savedState",
  ]
end