cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.3.2-0"
  sha256 arm:   "97c47aa56bbc9494ae8e2f252131491546a0bc55056c9e4a294049ff58c4f562",
         intel: "e874f623076368c8dff8f70debf91e09222a28020eb10aa870489b03ebf91897"

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