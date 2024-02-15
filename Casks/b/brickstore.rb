cask "brickstore" do
  version "2024.2.1"
  sha256 "9031da0f13016f778a139a032ea887d0ba4a8163b6e3f4729ae7918c422295ed"

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