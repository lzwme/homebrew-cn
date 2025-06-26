cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.7.0"
  sha256 arm:   "d6b57cc6afe11707d95c79d9db75095b06f1e225d0d8b281508333902edf71c1",
         intel: "8d6bdf12f8873d1bda06026aabd8847fbd2ad103ed297be866155e654ed11a09"

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