cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.12.0-0"
  sha256 arm:   "a4cf6ce6b45bfd5b3024408ae382aedab49ae1aee4a4a84933db7ab91ffa07d0",
         intel: "bd76527a8816049b7b7afd1b99607931661c78f82ad67a06ddd8d4f248d9ba64"

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