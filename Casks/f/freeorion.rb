cask "freeorion" do
  version "0.5.0.1"
  sha256 "c6436383071148dbc7b5d63981ae7afebda52340710f603b35f0e22a0aa9ecf5"

  url "https:github.comfreeorionfreeorionreleasesdownloadv#{version}FreeOrion_v#{version}_MacOSX_10.12.dmg",
      verified: "github.comfreeorion"
  name "FreeOrion"
  desc "Turn-based space empire and galactic conquest game"
  homepage "https:freeorion.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "FreeOrion.app"

  zap trash: [
    "~LibraryApplication SupportFreeOrion",
    "~LibrarySaved Application Stateorg.freeorion.FreeOrion.savedState",
  ]
end