cask "hoppscotch" do
  arch arm: "aarch64", intel: "x86_64"

  version "25.2.0-0"
  sha256 arm:   "12f2e308c894224e9f48c7c3e03e9d1d5d991cfe18ceba59604d31a85f2c546c",
         intel: "2161be897cc8b48e531ef5d1321f69ee8a296eb8b2e8729264326f9e0c7c357a"

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