cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.5.4-0"
  sha256 arm:   "f101153ecb6a79f3445bdc57361bae95a2b3f5186564491929dcd02fd85dd13e",
         intel: "b6252d02e8ea466c3bdedd90e3085282c3be4cad9f3e1e11edea34c095a35f4c"

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