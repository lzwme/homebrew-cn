cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.6.0-3"
  sha256 arm:   "b7d88728cb59278cdbb62fe3b8e28b8c36731ab736f61fc006ac0ce17917c1e3",
         intel: "9a4edfb453b65e7605993f16200655b0c4e703f8e86c26de17c0a1ba3555018d"

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