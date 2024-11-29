cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.11.0-0"
  sha256 arm:   "32f2da01447370d906fa41c588c6fbbe58ae7093b37ea537b247941968a22816",
         intel: "d8b96c0608aed8b5a42bcf95013ec5bd9d583c3b4d95afadf180d917419a9712"

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