cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.9.0-0"
  sha256 arm:   "c831c78de0ab00b17b0d4e92af0ffcac1926d9bbfd47aef6ea4d6284aa1082e7",
         intel: "b5b6b26a5e184512ebbbdf385751b0baf1bba04213fafce71f9af3eace0a919f"

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