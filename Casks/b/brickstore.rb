cask "brickstore" do
  version "2024.5.1"
  sha256 "54197154df603a2d5d4382b4746d8aff1f27f619dd0c62e8a0853e76df2404af"

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