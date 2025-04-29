cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.5.0"
  sha256 arm:   "d378f3e6489f7b80b52c9bf6ee785b39c1d56c323fd8b1e8d00e2d2509f2d068",
         intel: "eeadc3207bca2441ad2c4b047426d8995c8b25a71c52feaa7f98190792e18cf7"

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