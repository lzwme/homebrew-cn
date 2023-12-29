cask "quicksilver" do
  version "2.4.2"
  sha256 "b2fd0ad9a8d1edf25ab75bf231c8f7c481bd72ba9d565342714d9dc90e7766d3"

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