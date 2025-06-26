cask "spacesaver" do
  version "1.0.14"
  sha256 "9abe68b52052c8b90460985cec95edfe0c4a689a2c6e09f58d4eee1ae6f59235"

  url "https:github.comtranhuycongspace-saverreleasesdownloadv#{version}SpaceSaver-Installer.dmg",
      verified: "github.comtranhuycongspace-saver"
  name "SpaceSaver"
  desc "Application designed to help you manage and optimize your workspace"
  homepage "https:spacesaver.congdev.com"

  depends_on macos: ">= :monterey"

  app "SpaceSaver.app"

  zap trash: [
    "~LibraryCachescom.congth504.spacesaver",
    "~LibraryHTTPStoragescom.congth504.spacesaver",
    "~LibraryPreferencescom.congth504.spacesaver.plist",
  ]
end