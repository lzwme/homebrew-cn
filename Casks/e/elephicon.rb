cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.0.3"
  sha256 arm:   "60a6142f0a8f8f911cde1a09baa7b47c9ffd954e19d3bdff71bd209fe7e87c6e",
         intel: "f17eb82a984c21d2f649087b8865499df64a97727c773efc7400f8340dbecaa1"

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