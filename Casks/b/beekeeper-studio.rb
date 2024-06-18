cask "beekeeper-studio" do
  arch arm: "-arm64"

  version "4.6.0"
  sha256 arm:   "7ff7009135b17d38a66f3762c0eaf36069bafe2860a270154154c4342a6be75f",
         intel: "f5b2174f6a6372d195d613d4b5a1998c58e55acc7a803f8bc4d4a9d9381835e1"

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