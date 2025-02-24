cask "slippi-dolphin" do
  version "3.4.5"
  sha256 "3c6ad073a50dfc01456265850bad1f178316f690374f79023ab15a9d79e1039c"

  url "https:github.comproject-slippiIshiirukareleasesdownloadv#{version}FM-Slippi-#{version}-Mac.dmg",
      verified: "github.comproject-slippiIshiiruka"
  name "Slippi"
  desc "Fork of the Dolphin GameCube and Wii emulator with netplay support via Slippi"
  homepage "https:slippi.gg"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Slippi Dolphin.app"

  zap trash: [
    "~LibraryApplication SupportDolphin",
    "~LibraryPreferencescom.project-slippi.dolphin.plist",
  ]

  caveats do
    requires_rosetta
  end
end