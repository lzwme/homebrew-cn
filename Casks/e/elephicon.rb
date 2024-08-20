cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.0.5"
  sha256 arm:   "6b8a2a76d704486db120b0a2f6de82713e29aa00de2261fc25ae9f18fa8a1736",
         intel: "605d6759121a5bec13c82bd0d53ae1f962f88f083f8bfd4f43142816c80ec41f"

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