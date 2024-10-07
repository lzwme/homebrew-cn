cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.9.1-0"
  sha256 arm:   "d076ea7774cc571720028635f91e82178c4658fd7226523587d8011e69abce0a",
         intel: "a27560ac27185521509d4756136db057cdb709dadf6c6adb152b644dc2eedf3f"

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