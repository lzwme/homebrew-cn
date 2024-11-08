cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.1.2"
  sha256 arm:   "8b1f145937749fa88fae989f38e38cc1aaf09c6647fd0551a30780b63d79922a",
         intel: "00876abc75c7230aa132772602218ee09b396dba70fa4e3b11c84040d11040f2"

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