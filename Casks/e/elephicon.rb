cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.0.0"
  sha256 arm:   "464122baad22740bd796917991c02cfda725ec60ff8b0af7a7dfa48d2541a180",
         intel: "d3fab74f296558f6c4ebcc1af8b49170e0a05da86c5b074c8a2c7045939620e3"

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