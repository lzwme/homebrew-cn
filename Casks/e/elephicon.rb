cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.8.4"
  sha256 arm:   "98ca82ea1ee11c3a309eeb6b4e6852200f933d9fc08b7836d8b7f78996707619",
         intel: "d4ee926a0140410f8e4c81ec7b58ab2db56f1018f909a257efb030e44fafd24c"

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