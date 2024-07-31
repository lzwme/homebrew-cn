cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.7.0-0"
  sha256 arm:   "3928ba42605b1f836f3be004a817017c33a682c21765ca05942ed35ce7818317",
         intel: "91b3df78dd021b3c9dac058569b044a07243e874f0726e0777d89640ac860279"

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