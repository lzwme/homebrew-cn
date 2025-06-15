cask "icon-shelf" do
  arch arm: "-arm64"

  version "0.1.28"
  sha256 arm:   "f1d730568828de64d564ef2e103abbb4e88599ddd52b971edcbbd84da7d08a25",
         intel: "10ae5e9ea61a9cf852dd7371a13fc1d255b86422c16b9c30aa26d6d1de999f36"

  url "https:github.comIcon-Shelficon-shelfreleasesdownloadv#{version}Icon-Shelf-#{version}#{arch}.dmg",
      verified: "github.comIcon-Shelficon-shelf"
  name "Icon Shelf"
  desc "Icon manager for web developers"
  homepage "https:icon-shelf.github.io"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Icon Shelf.app"

  zap trash: [
    "~LibraryLogsIcon Shelf",
    "~LibraryPreferencescom.IconShelf.app.plist",
    "~LibrarySaved Application Statecom.IconShelf.app.savedState",
  ]
end