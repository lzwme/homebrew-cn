cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.3.0"
  sha256 arm:   "72ba288a81e8c28618ba44a7b0b2f469bbce414ca10c0f1d2b55d424aac7fe95",
         intel: "158c55a8927283528c2d5eda0d689bb08b56546161736264817cb8da622ae4b0"

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