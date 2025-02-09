cask "freeorion" do
  version "0.5.1"
  sha256 "74a1245eb6eca926d296a9cfc8d42ffdc7719db3aa796702c265d7be3cccf5c3"

  url "https:github.comfreeorionfreeorionreleasesdownloadv#{version}FreeOrion_v#{version}_macOS_10.15.dmg",
      verified: "github.comfreeorion"
  name "FreeOrion"
  desc "Turn-based space empire and galactic conquest game"
  homepage "https:freeorion.org"

  livecheck do
    url :url
    strategy :github_latest
  end

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