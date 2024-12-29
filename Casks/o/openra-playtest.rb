cask "openra-playtest" do
  version "20241228"
  sha256 "a4a4a3e9802eb44a352204ae89d4667618b0776f5d961fbcd50958f282ca0f9f"

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