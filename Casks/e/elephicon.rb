cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.8.5"
  sha256 arm:   "74256cf6fe07df15e70b95454e0770f00c9743c97fb43915715408e50decf8e7",
         intel: "24ad8eafa603fb1c2d1048db310a03c1ebf96ca4a49773224eb6b3a604a9e48a"

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