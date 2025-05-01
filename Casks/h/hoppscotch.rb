cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.4.0-0"
  sha256 arm:   "8611170d7996257e23500e7d66b6e24f1300abd80f5c8fc70875824141376914",
         intel: "6d7390b0db903ab6f12503405c530d0c3f020e90add9598f1c48e35cb7d0b494"

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