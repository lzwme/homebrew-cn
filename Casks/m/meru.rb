cask "meru" do
  arch arm: "-arm64"

  version "3.8.2"
  sha256 arm:   "179aa9302a201bf1fc948964bbc1da87b20f785cdfc7a4d21db9c691dff5471c",
         intel: "b6360400f36ed19237066864e6f23da632f2ef945719abfead223c287ba10a81"

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