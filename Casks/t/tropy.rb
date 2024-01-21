cask "tropy" do
  arch arm: "-arm64"

  version "1.15.2"
  sha256 arm:   "73587dcbdb4bd62a7c3ae52bbbf701ca3a341d630f8bfcaa631f2fca76c71678",
         intel: "14bc1b69c4dd0068db5471ac1b4a0b0ccf242db3551c4e72b22e3053e7cfa645"

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