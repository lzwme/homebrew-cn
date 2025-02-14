cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.3.3"
  sha256 arm:   "a976a156d09fef3b7b04ce9f0e6e986cead56de7b1e244bb4b695ec92f861be2",
         intel: "6f9c9b3cba10e449d5227b464069496fec18e01d4317315c88115d1d8828a26e"

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