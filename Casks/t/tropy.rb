cask "tropy" do
  arch arm: "-arm64"

  version "1.16.2"
  sha256 arm:   "3dc286d185f1fead018d628421bdf29a470a587e6ec64245495a35dafd79a3be",
         intel: "595d4da00f680767f5b9b48a16510216833cbbeaf50b8b8b2a03b89985765e8e"

  url "https:github.comtropytropyreleasesdownloadv#{version}tropy-#{version}#{arch}.dmg",
      verified: "github.comtropytropy"
  name "Tropy"
  desc "Research photo management"
  homepage "https:tropy.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Tropy.app"

  zap trash: [
    "~LibraryApplication SupportTropy",
    "~LibraryCachesorg.tropy.tropy",
    "~LibraryCachesorg.tropy.tropy.ShipIt",
    "~LibraryCachesTropy",
    "~LibraryLogsTropy",
    "~LibraryPreferencesorg.tropy.tropy.plist",
    "~LibrarySaved Application Stateorg.tropy.tropy.savedState",
  ]
end