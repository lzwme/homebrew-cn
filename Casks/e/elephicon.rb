cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.0.1"
  sha256 arm:   "b0bc4688ddd870afba4f1983ff8988c0f1a7af43a9d8f77a51c2d376a00c366a",
         intel: "9547dbfd634a739a17c34be8309d2dd5991dda338d817798054a7a20ffb06996"

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