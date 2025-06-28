cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.7.1"
  sha256 arm:   "3c2ecfc579ffa4a21671d3a6504402504ef907394eb53327f4e21afb197b905d",
         intel: "dfa267d2add62ca9739c48fe47e954335661bfce3ef5edec70b69c4a69e6e538"

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