cask "meru" do
  arch arm: "-arm64"

  version "3.4.2"
  sha256 arm:   "0eb6ca61dde267d41a0ebb73b85b5b11b985e4ed1a94bc80aa438e29ba3b54f4",
         intel: "d8c504f6e00941dfe40bbaaad4644f6e57a624884f8dffd7b1ed86c5fcec6d62"

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