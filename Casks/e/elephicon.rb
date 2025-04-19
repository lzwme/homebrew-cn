cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.4.3"
  sha256 arm:   "4d88c4df469bb875136454c4cb056e86e1fffdfed5eca237c41e141834dcd351",
         intel: "51e9f0119fa527b4aa8d9338b1b2a2e79500d852f420bb78c8b40eaebbfb471e"

  url "https:github.comsprout2000elephiconreleasesdownloadv#{version}Elephicon-#{version}-darwin-#{arch}.dmg"
  name "Elephicon"
  desc "Create icns and ico files from png"
  homepage "https:github.comsprout2000elephicon"

  auto_updates true
  depends_on macos: ">= :big_sur"

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