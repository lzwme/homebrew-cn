cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.9.1"
  sha256 arm:   "2ea2e09792c799d6caef39ae7f3b00a6fb7fcaca0820ccec46bf04754f1c5932",
         intel: "eb486e8f4f0a2658ca1d4f076ccbebf771e901cedda9dd22a09d887e265d11db"

  url "https:github.comsprout2000elephiconreleasesdownloadv#{version}Elephicon-#{version}-darwin-#{arch}.dmg"
  name "Elephicon"
  desc "Create icns and ico files from png"
  homepage "https:github.comsprout2000elephicon"

  auto_updates true

  app "Elephicon.app"

  zap trash: [
    "~LibraryApplication SupportElephicon",
    "~LibraryCachesjp.wassabie64.Elephicon",
    "~LibraryCachesjp.wassabie64.Elephicon.ShipIt",
    "~LibraryLogsElephicon",
    "~LibraryPreferencesjp.wassabie64.Elephicon.plist",
    "~LibrarySaved Application Statejp.wassabie64.Elephicon.savedState",
  ]
end