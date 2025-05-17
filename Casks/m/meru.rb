cask "meru" do
  arch arm: "-arm64"

  version "3.5.1"
  sha256 arm:   "5e81fcbba7d5ccc62744a4623dee453f94bae5d08b5e5ab3ac7c0b7611ae7d15",
         intel: "7d5a39ed37efd4d0b31b3236bc0cada229326b28d0f1c51937a75f2a9638eec8"

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