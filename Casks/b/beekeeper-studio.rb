cask "beekeeper-studio" do
  arch arm: "-arm64"

  version "5.2.12"
  sha256 arm:   "efd22888604fa39ed379c505fb09871e21c9addb6c8b3fefb00a63a826cac53a",
         intel: "af19a501f639e62f92cbab4794f9d4919077cb3cf56d6fc17103508d1e3645ac"

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