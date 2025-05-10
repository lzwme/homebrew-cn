cask "meru" do
  arch arm: "-arm64"

  version "3.3.0"
  sha256 arm:   "30f12be076dcec29f002eb92dd6f1e0d1d8a3b83632a285dd35c107ce2e0d27a",
         intel: "4062506d25d41565b87783f4f3dbbb06f8e4fdafc17347ff637786545a365cad"

  url "https:github.comzoidshmerureleasesdownloadv#{version}Meru-#{version}#{arch}.dmg",
      verified: "github.comzoidshmeru"
  name "Meru"
  desc "Gmail desktop app"
  homepage "https:meru.so"

  depends_on macos: ">= :big_sur"

  app "Meru.app"

  zap trash: [
    "~LibraryApplication SupportMeru",
    "~LibraryCachesmeru-updater",
    "~LibraryCachessh.zoid.meru",
    "~LibraryCachessh.zoid.meru.ShipIt",
    "~LibraryHTTPStoragessh.zoid.meru",
    "~LibraryLogsMeru",
    "~LibraryPreferencessh.zoid.meru.plist",
    "~LibrarySaved Application Statesh.zoid.meru.savedState",
    "~LibraryWebKitsh.zoid.meru",
  ]
end