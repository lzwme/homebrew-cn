cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.8.2-0"
  sha256 arm:   "50d7a93da1afff307dcf1f4156be3b503669ce8444ede38113dda6f717d3b484",
         intel: "916c73cbd50fdfd53ca017ea8c7eea622f47302b0bf73708c92510891ddf380e"

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