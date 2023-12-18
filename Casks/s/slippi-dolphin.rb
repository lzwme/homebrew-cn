cask "slippi-dolphin" do
  version "3.3.1"
  sha256 "ec7acce03bb8547c95b5b3c257073f875e7839c15e3a2c6845937002fc59ae4f"

  url "https:github.comproject-slippiIshiirukareleasesdownloadv#{version}FM-Slippi-#{version}-Mac.dmg",
      verified: "github.comproject-slippiIshiiruka"
  name "Slippi"
  desc "Fork of the Dolphin GameCube and Wii emulator with netplay support via Slippi"
  homepage "https:slippi.gg"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Slippi Dolphin.app"

  zap trash: [
    "~LibraryApplication SupportDolphin",
    "~LibraryPreferencescom.project-slippi.dolphin.plist",
  ]
end