cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.12.2-0"
  sha256 arm:   "b0453adaa023bce95f46ff8b1e0bce960154197273244a70861b1e1bce496fec",
         intel: "cba4de53658a0e219a96aab8f60a67979f7386154dff141ce289596c8647b43f"

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