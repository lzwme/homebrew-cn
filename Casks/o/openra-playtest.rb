cask "openra-playtest" do
  version "20241116"
  sha256 "a1fd4ae2a1916930dc0a4269de68be52a6c570888da4db992cd69b52213ff2a5"

  url "https:github.comOpenRAOpenRAreleasesdownloadplaytest-#{version}OpenRA-playtest-#{version}.dmg",
      verified: "github.comOpenRAOpenRA"
  name "OpenRA (playtest)"
  desc "Real-time strategy game engine for Westwood games"
  homepage "https:www.openra.net"

  livecheck do
    url :url
    regex(^playtest[._-]v?(\d+(?:[.-]\d+)*)$i)
  end

  conflicts_with cask: "openra"

  app "OpenRA - Dune 2000.app"
  app "OpenRA - Red Alert.app"
  app "OpenRA - Tiberian Dawn.app"

  zap trash: [
    "~LibraryApplication SupportOpenRA",
    "~LibrarySaved Application Statenet.openra.mod.cnc.savedState",
    "~LibrarySaved Application Statenet.openra.mod.d2k.savedState",
    "~LibrarySaved Application Statenet.openra.mod.ra.savedState",
  ]
end