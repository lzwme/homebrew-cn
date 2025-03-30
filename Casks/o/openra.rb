cask "openra" do
  version "20250330"
  sha256 "76f0b5e41c2bd2af331b51b73ed1e43bed833e457926f095bdf59b772d65de27"

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