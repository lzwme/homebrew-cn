cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.5.2"
  sha256 arm:   "44a35160505181c78eb11706dd4c58e8600de49ceabc2061ce37a324eec6784b",
         intel: "6d762ef1692171a7c3a176bc671e32e845f3be3c95c077c9f2e9aca5c4f5b510"

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