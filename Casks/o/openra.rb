cask "openra" do
  version "20250330"
  sha256 "2a78cd58603fd06ed6006ae5916065455a7ac7c1290dba1d06c0292bad4238ab"

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