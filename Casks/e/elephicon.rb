cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.1.1"
  sha256 arm:   "7fe1becaad4e4c88fb5712db57529bc513017a3ca8de2ff388cbbce80bed77bc",
         intel: "9ad361abe86c5a4f64558cfadf7506f324d18ccf682c4db0d18a86bf2a552057"

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