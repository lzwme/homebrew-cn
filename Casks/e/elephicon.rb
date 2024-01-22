cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.8.3"
  sha256 arm:   "cfc0101b27190269017335c568e95e3ab5080b8008a6b4f5644ecbc91426bf96",
         intel: "a704bdf4fedc8b0d97ad8e3e1ecb2185c9f3b1cdbb456b2bdeea68a82d3add50"

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