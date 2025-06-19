cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.5.5"
  sha256 arm:   "b994bf11a8708312ee5d4f8ebd3973bc77407e0781b27db5e3371decdb86d180",
         intel: "2271215699f80a105d7ff54386efb7a91c1ae2a39ea9e1d7c7c0df2715115d7c"

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