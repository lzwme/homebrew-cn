cask "openra@playtest" do
  version "20250220"
  sha256 "d855c90cb7e27e6d8c6fa6bb42211c0a572c3c57a541623c844d0b41de12eaff"

  url "https:github.comOpenRAOpenRAreleasesdownloadplaytest-#{version}OpenRA-playtest-#{version}.dmg",
      verified: "github.comOpenRAOpenRA"
  name "OpenRA (playtest)"
  desc "Real-time strategy game engine for Westwood games"
  homepage "https:www.openra.net"

  livecheck do
    url :url
    regex(^playtest[._-]v?(\d+(?:[.-]\d+)*)$i)
  end

  no_autobump! because: :requires_manual_review

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