cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "3.2.1"
  sha256 arm:   "77b9c290dee2b8ba046c1c31de167780c32d1e4712b2cb527e850b538525643f",
         intel: "6fe61ca52e1c69963b14828165b9c08341f0bc17cca003060c33110d2a0fd727"

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