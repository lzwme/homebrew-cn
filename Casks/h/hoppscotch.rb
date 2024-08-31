cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.8.0-0"
  sha256 arm:   "b7d61d7756e3ddb04b092ea9267ffd460599a2a1e0a0de4818e594895333fc99",
         intel: "10c04e3a71f9048fcf7ccf649516c2756f8d8151b38158c71b0c9d66a9234b11"

  url "https:github.comhoppscotchreleasesreleasesdownloadv#{version}Hoppscotch_mac_#{arch}.dmg"
  name "Hoppscotch"
  desc "Open source API development ecosystem"
  homepage "https:github.comhoppscotchhoppscotch"

  depends_on macos: ">= :high_sierra"

  app "Hoppscotch.app"

  zap trash: [
    "~LibraryApplication Supportio.hoppscotch.desktop",
    "~LibraryCachesio.hoppscotch.desktop",
    "~LibrarySaved Application Stateio.hoppscotch.desktop.savedState",
    "~LibraryWebKitio.hoppscotch.desktop",
  ]
end