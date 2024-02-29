cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.9.2"
  sha256 arm:   "92de20268fcec76b64aec6705b50d89159cb7781c740f5c5db62610927cc5ac6",
         intel: "a0653ab7c69ba9ff2c67622356c9241b7807e7a9a9c27ba1ad4a28480928555b"

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