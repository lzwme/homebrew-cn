cask "quicksilver" do
  version "2.5.0"
  sha256 "f22b8d9ecc60e00e85eebb5187abdfa733420acac567011e6609195e3a7e2999"

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