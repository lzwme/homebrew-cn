cask "freeorion" do
  version "0.5.1.1"
  sha256 "1bd19baeeb8c74da8510d078623a4689fecbc91de780809e838563900fab29c8"

  url "https:github.comfreeorionfreeorionreleasesdownloadv#{version}FreeOrion_v#{version}_MacOSX_10.15.dmg",
      verified: "github.comfreeorion"
  name "FreeOrion"
  desc "Turn-based space empire and galactic conquest game"
  homepage "https:freeorion.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "FreeOrion.app"

  zap trash: [
    "~LibraryApplication SupportFreeOrion",
    "~LibrarySaved Application Stateorg.freeorion.FreeOrion.savedState",
  ]

  caveats do
    requires_rosetta
  end
end