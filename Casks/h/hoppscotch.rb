cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.10.2-0"
  sha256 arm:   "7f45a0dc71d55f93485bb45f91ee76fe49da19f3de64ba596f92999336a1e065",
         intel: "ad267a1781115a3e4495f5805e70f4bd5ac0d8998c29974178c5acaf5e616c67"

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