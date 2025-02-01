cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.1.0-0"
  sha256 arm:   "fe01bf380727f49a8729d9bcaf582b834bee0f5d7ce32a3845ab110191c10856",
         intel: "8ba79223747fb8136fd6fc128b16c34bb15e3f81c0b91d5c421ae3e41657872d"

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