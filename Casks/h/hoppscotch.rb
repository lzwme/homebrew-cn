cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.5.2-0"
  sha256 arm:   "53568417dde471cd4839d631e2b776c8a9dc00c4eb8a8d0d47c6a71a47a06af6",
         intel: "f3258c665333873cb35742030a9d1a9446cf4583ca64b52e4396de0aaa251510"

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