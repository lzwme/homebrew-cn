cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "23.12.3-1"
  sha256 arm:   "6f82e27123c301da3362dd3b65c67bb18e34d4b36ef4e9bfe48cd7f20e9979ac",
         intel: "2d655789375afbdaf101983db71eb6d6575d5b0bb2aa75e4a01f4459deb4e39b"

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