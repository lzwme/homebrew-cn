cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.5.0"
  sha256  arm:   "ae60f1f17d8ebe74fc6b0906b6dd0505e677c27cdd00a4ff7f65474390f7c124",
          intel: "7d349a9e83c22b0e72da00a5231c19f9f9674e985a10e104a7a7e981830d8f16"

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