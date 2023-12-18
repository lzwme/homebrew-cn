cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "23.8.4-1"
  sha256 arm:   "7e58a5aa6cbcf7d1381181f7f9bfd44d69f4213229e69097356baed530be4ff9",
         intel: "d17a6981bc900811d01327c526101f568514183c83d870582710f28b9e242b01"

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