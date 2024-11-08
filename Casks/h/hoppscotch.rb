cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.10.1-0"
  sha256 arm:   "78f6653daa39d0a29f2ec945ea2037afc9acb0a935290765eacf9178fc3adccf",
         intel: "49cd5279242a615cc67c79ed6e0a92a1b258bafb1b2d598c25fa2482b0a9b4a0"

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