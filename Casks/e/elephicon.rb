cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.0.4"
  sha256 arm:   "b183b3dea2ebd3c6558387ecc623a288f8186f3544bc529aa6d4fa49e42a4674",
         intel: "ad6f853effd32343aee4bee0efc5e0f36c9d1ad141619d64aac146968b636159"

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