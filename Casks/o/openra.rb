cask "openra" do
  version "20231010"
  sha256 "da81dfcfab8287f21127827e029a0553bde08207a15656393c9e3c1d6341d3c4"

  url "https:github.comOpenRAOpenRAreleasesdownloadrelease-#{version}OpenRA-release-#{version}.dmg",
      verified: "github.comOpenRAOpenRA"
  name "OpenRA"
  desc "Real-time strategy game engine for Westwood games"
  homepage "https:www.openra.net"

  livecheck do
    url :url
    regex(^release[._-]v?(\d+(?:[.-]\d+)*)$i)
  end

  conflicts_with cask: "openra-playtest"

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