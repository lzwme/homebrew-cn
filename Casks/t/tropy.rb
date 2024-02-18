cask "tropy" do
  arch arm: "-arm64"

  version "1.16.0"
  sha256 arm:   "6f9a70a9db9519c24ca2067574774b35d2f9e5f213a8de1038ac50c6c9152633",
         intel: "5219de68da5fceca7d29b7ae746a259168dc1e9a5e14e043d78a1f48d930b36e"

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