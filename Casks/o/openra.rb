cask "openra" do
  version "20250303"
  sha256 "3e2239d9776e660d49ce509cf318a305eed086feccaa799c0f7c3b0c0b1d0d1b"

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