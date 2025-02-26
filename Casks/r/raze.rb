cask "raze" do
  version "1.11.0"
  sha256 "b7980849a507cfcfeaf8f76298c032bfe4415b2f246f41e3c0c9a6291770c70c"

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