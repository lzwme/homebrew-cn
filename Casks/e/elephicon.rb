cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.5.3"
  sha256 arm:   "4c7b5c688135a0caa7f0540c9457b520dff0cff73f6d22ae8c7620a32c3c1295",
         intel: "e71f7b3c41f39aa64f744a784e2fa5ae07df72fce125e7d498a807a842f2f470"

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