cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.2.0"
  sha256 arm:   "1ac8699783bcda8094c31e72988821264ac305d808b203784aaa04bc448ca21c",
         intel: "211902102324a27a231719749caaa4e9fd21faf2307a564c1756c1eb9cee784a"

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