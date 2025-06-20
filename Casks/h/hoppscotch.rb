cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.5.3-0"
  sha256 arm:   "121c13439db15022d2029576bcda3802a9c0ce7683692583b77dfda66c09bd85",
         intel: "0344ace892dc1da1f9a7b4d0ebb4d5000adefa7b7cda1c5581966016fa015b30"

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