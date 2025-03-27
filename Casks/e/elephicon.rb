cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.4.1"
  sha256 arm:   "c25e0c3afb26c4eb1e6df7317a36983e60e9b4ab9b185651bd9f372bd614e3b4",
         intel: "d40bb2c94ec89eab77d213eb374a44f3c9960cdeae092d014ffee2c04a313dd9"

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