cask "brickstore" do
  version "2024.1.4"
  sha256 "8d8939658fbda0d3c90815a983e0b03b731906bf56f59e6234e2d541cdd281e7"

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