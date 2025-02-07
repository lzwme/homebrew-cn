cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.3.1"
  sha256 arm:   "c21d543818e9bead0f02ecf396317c006cb76827dd99f337dbf7343cef322c42",
         intel: "08861ae138bf6bb54fd7fdbfef4e542def335a34adc34b79179dbbd48882bde6"

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