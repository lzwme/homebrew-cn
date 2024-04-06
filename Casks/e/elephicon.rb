cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.9.3"
  sha256 arm:   "f1882a03bd256c725fc158e0918ceb190a3606d240bd8d1d9ded8ead8210d93f",
         intel: "2e5f9e820657fb78f403e6075a87ecc7c503384e7f70da1f102be06943ecdb06"

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