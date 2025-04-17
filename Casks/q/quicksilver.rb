cask "quicksilver" do
  version "2.5.1"
  sha256 "4b7a86d371ecbf739ea0461d3adccaa4d79e9056d13e77ca14a3c8dbf2812cb4"

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
  depends_on macos: ">= :mojave"

  app "Quicksilver.app"

  zap trash: [
    "~LibraryApplication SupportQuicksilver",
    "~LibraryPreferencescom.blacktree.Quicksilver.plist",
  ]
end