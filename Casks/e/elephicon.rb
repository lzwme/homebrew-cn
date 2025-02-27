cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.3.4"
  sha256 arm:   "f5a0beafc399438c4540d3bca24be4b8ecf78c774b90d93f81a7d42dde70a3a9",
         intel: "15fdbbf52b5b84ad3b4e460417e2fa5485853cf5f42b40ec8bfca62526cfce94"

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