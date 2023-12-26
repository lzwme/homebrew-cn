cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.8.1"
  sha256 arm:   "59cdc33fe6447a42b840c6414b0c311fc2c4aa867d5e900cdd46dba17bfa59da",
         intel: "ae94ee0218987615f9f51241c10747b9265699498a3e49bdee2ae6b500711fcd"

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