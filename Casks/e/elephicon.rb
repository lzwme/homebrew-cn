cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.8.2"
  sha256 arm:   "b388f8efdd8af7c533bdd608ffa3344fd9a86274b2163d41dc823b589e1d0311",
         intel: "87000785d9e079c306ed3164916c8413256eb2bd72d1f93e55528242f63c695d"

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