cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.8.6"
  sha256 arm:   "bead3ab1d7e060d033badcc1f46f9fc89823fbbd64a550f56371e8617cf92bae",
         intel: "ea00537ded0d53f68bd04152a472503506c26089e9a1564340ebae883e32d726"

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