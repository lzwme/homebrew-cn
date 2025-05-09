cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.4.2-0"
  sha256 arm:   "7f702be50526d4c27f91f2d1b23c405359ae76926153adeec4476ed7b636ae6a",
         intel: "436d570fe2d6c7a6ffd9ee2a51a6c3a63c5a27b875cb3d93e196f22035809631"

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