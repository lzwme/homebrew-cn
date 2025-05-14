cask "meru" do
  arch arm: "-arm64"

  version "3.4.1"
  sha256 arm:   "a73c47718633f4ef47c7515512bdaf5b31cbb6bc56077bc313b5da30bf55e9f6",
         intel: "ea92c8e697af81f638e9b5af21d2ec2c23fa7856e81d0cf7806bfbfb99b8fa95"

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