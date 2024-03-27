cask "brickstore" do
  version "2024.3.1"
  sha256 "84e8577256a855011384a78f39b405c515a4a56df782af1a009ec1025f0d9314"

  url "https:github.comrgrieblbrickstorereleasesdownloadv#{version}macOS-BrickStore-#{version}.dmg",
      verified: "github.comrgrieblbrickstore"
  name "BrickStore"
  desc "BrickLink offline management tool"
  homepage "https:www.brickstore.dev"

  app "BrickStore.app"

  zap trash: [
    "~LibraryPreferencesde.brickforge.brickstore.plist",
    "~LibraryPreferencesorg.brickstore.BrickStore.plist",
    "~LibrarySaved Application Statede.brickforge.brickstore.savedState",
  ]
end