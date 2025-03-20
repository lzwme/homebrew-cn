cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.2.3-0"
  sha256 arm:   "ecbd24248538d60905ec896e82e0f025b3e0f1791803d6e8ea55c2741f9ac75b",
         intel: "0307b7283344e3445db79e454288ca43b18c55014a91637a805ddb53685e47f3"

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