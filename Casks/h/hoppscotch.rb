cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.8.1-0"
  sha256 arm:   "4dcea541b3191d7e169744777c60a546bdbb7c54eb613c4cb409123c2c3c9abc",
         intel: "7375079edacb4685df9b3f0b2f75eef268c1b727fde76fed60c16a6d3c84091d"

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