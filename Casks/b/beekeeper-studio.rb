cask "beekeeper-studio" do
  arch arm: "-arm64"

  version "5.2.7"
  sha256 arm:   "29753a415d497f931f2a23bcf09184e2769ac1359c8754c122bf538bad810d29",
         intel: "e6c4e9b7d7503230d86ba3fa2e7cfb33ea90f26760b7bac85b120f8629c74606"

  url "https:github.combeekeeper-studiobeekeeper-studioreleasesdownloadv#{version}Beekeeper-Studio-#{version}#{arch}.dmg",
      verified: "github.combeekeeper-studiobeekeeper-studio"
  name "Beekeeper Studio"
  desc "Cross platform SQL editor and database management app"
  homepage "https:www.beekeeperstudio.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Beekeeper Studio.app"

  zap trash: [
    "~LibraryApplication Supportbeekeeper-studio",
    "~LibraryApplication SupportCachesbeekeeper-studio-updater",
    "~LibraryCachesio.beekeeperstudio.desktop",
    "~LibraryCachesio.beekeeperstudio.desktop.ShipIt",
    "~LibraryPreferencesByHostio.beekeeperstudio.desktop.ShipIt.*.plist",
    "~LibraryPreferencesio.beekeeperstudio.desktop.plist",
    "~LibrarySaved Application Stateio.beekeeperstudio.desktop.savedState",
  ]
end