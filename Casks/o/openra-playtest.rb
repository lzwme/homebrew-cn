cask "openra-playtest" do
  version "20230927"
  sha256 "975261f592b4452662e5064afbbefab0ae4d735763c402ef453ec1dc4443e76d"

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