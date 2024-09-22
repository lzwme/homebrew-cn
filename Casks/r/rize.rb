cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.3.27"
  sha256  arm:   "439ee88f2a8e40e14501b5c4777c5d6c82b58a44b95a7bf426de67464a99e414",
          intel: "542fa0e5c344227cf4c8dd1572045d1438a087d61f3d5f270930943eb3cd2085"

  url "https:github.comrize-ioluareleasesdownloadv#{version}Rize-#{version}-#{arch}.dmg",
      verified: "github.comrize-iolua"
  name "Rize"
  desc "AI time tracker"
  homepage "https:rize.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Rize.app"

  zap trash: [
    "~LibraryApplication SupportRize",
    "~LibraryCachesio.rize",
    "~LibraryCachesio.rize.ShipIt",
    "~LibraryHTTPStoragesio.rize",
    "~LibraryPreferencesio.rize.plist",
    "~LibrarySaved Application Stateio.rize.savedState",
  ]
end