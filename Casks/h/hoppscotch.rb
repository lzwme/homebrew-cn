cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.3.4-1"
  sha256 arm:   "4e1f6ce98f87d882deea41b8edd5b6d09745fa8a13e17d43d2dfc6881d6c042f",
         intel: "c3d1f70254a61a793243cc60dcdafb4b2994160675dacb42ddc3a8e5f4c12bfe"

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