cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "24.9.3-0"
  sha256 arm:   "18055adb06ca89e872a7e5248e344a0057a6e3892f253447637fad076641bed1",
         intel: "18d930ff6567e13d0f61c16dc5b0e66594591be059ad1a82b5961e6226061646"

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