cask "tropy" do
  arch arm: "-arm64"

  version "1.16.1"
  sha256 arm:   "5f8718d78e1baf74ae379a2c90bc93a95baf2e4490f666ae23052f2528c095f5",
         intel: "5799380b2ea9da6182b2c616ca68b3e32dafa711bf451340da60af72beb05171"

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