cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "23.12.3-2"
  sha256 arm:   "5e342fff81050dafd9317be99d613ac5204a2b3c10a5a30bb5b161d61455e001",
         intel: "35fb3452bc2cc820fee64cbc85543f4b5567d747b21cd4085cd76f1ebf153a29"

  url "https:github.comhoppscotchreleasesreleasesdownloadv#{version}Hoppscotch_mac_#{arch}.dmg"
  name "Hoppscotch"
  desc "Open source API development ecosystem"
  homepage "https:github.comhoppscotchhoppscotch"

  depends_on macos: ">= :high_sierra"

  app "Hoppscotch.app"

  zap trash: [
    "~LibraryApplication Supportio.hoppscotch.desktop",
    "~LibraryCachesio.hoppscotch.desktop",
    "~LibrarySaved Application Stateio.hoppscotch.desktop.savedState",
    "~LibraryWebKitio.hoppscotch.desktop",
  ]
end