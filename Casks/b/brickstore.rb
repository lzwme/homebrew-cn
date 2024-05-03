cask "brickstore" do
  version "2024.5.2"
  sha256 "e1c13583fff821f1accad237576a4be84a6a85d05590a28a58dd7d1a3974df99"

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