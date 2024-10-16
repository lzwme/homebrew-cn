cask "quicksilver" do
  version "2.4.3"
  sha256 "c2c67ce3687eecb75110220a71a5621089f47f5c6edc0c12a60356e538d2f844"

  url "https:github.comquicksilverQuicksilverreleasesdownloadv#{version}Quicksilver.#{version}.dmg",
      verified: "github.comquicksilverQuicksilver"
  name "Quicksilver"
  desc "Productivity application"
  homepage "https:qsapp.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Quicksilver.app"

  zap trash: [
    "~LibraryApplication SupportQuicksilver",
    "~LibraryPreferencescom.blacktree.Quicksilver.plist",
  ]
end