cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.9.2-0"
  sha256 arm:   "db1b4c3e76cfad4ef633350feae0b3d46e488169eea9ff0975b71b7c53f18896",
         intel: "e53d807eb1fd4f43e1effc8ba067912c7be25a945af1e065de8802f9a8dc3f1e"

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