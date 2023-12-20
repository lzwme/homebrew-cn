cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "23.12.0-1"
  sha256 arm:   "747282846f80456a023aad566ee0427b35321cf58a6a1a18be0c143b8d461eb3",
         intel: "3a1156c328195de02119b8b65b1b7065ab000afb9fd994aabe716d94dcb6e8c3"

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