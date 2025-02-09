cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.3.2"
  sha256 arm:   "3b92d0739d8e4ac48be48a698652e1fe360fa36459f0a75637f2d6c4d214bba8",
         intel: "dc15b6987d409b20581486b1e54194d135d37b2b1678685996471329eee2fd12"

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