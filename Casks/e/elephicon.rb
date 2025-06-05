cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.5.4"
  sha256 arm:   "0978d7563ad9d874b845236300e3894fddaa88e0faf95f3ca2061c062f559295",
         intel: "6c2b3d24269a4f4622e68c9de7530aae5886745d9e8e13b0fe5aa732232cae87"

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