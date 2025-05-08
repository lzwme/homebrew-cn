cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.4.1-0"
  sha256 arm:   "de554e02dc1476b43fadab9fb0fdb6b125add126adcb2eb66f7e71e548baab28",
         intel: "01b0ebfd16dfe126f845335d9aad38f8858fe132385eb0eb9168a652fe873ae8"

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