cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.3.0-0"
  sha256 arm:   "7b6b08889846bf8e2f44f952cf643bc6a75729609522c1b9e581480ee25d524f",
         intel: "d94bc3cf4428a3ef8aa8d2eb4935f495452795105bdf0a4d01bbfd0b78a44d9b"

  url "https:github.comhoppscotchreleasesreleasesdownloadv#{version}Hoppscotch_mac_#{arch}.dmg",
      verified: "github.comhoppscotchreleases"
  name "Hoppscotch"
  desc "Open source API development ecosystem"
  homepage "https:hoppscotch.com"

  depends_on macos: ">= :high_sierra"

  app "Hoppscotch.app"

  zap trash: [
    "~LibraryApplication Supportio.hoppscotch.desktop",
    "~LibraryCachesio.hoppscotch.desktop",
    "~LibrarySaved Application Stateio.hoppscotch.desktop.savedState",
    "~LibraryWebKitio.hoppscotch.desktop",
  ]
end