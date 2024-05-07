cask "rectangle" do
  version "0.79"
  sha256 "5dccf080b38d4edef02fea16d6bbb0eb007065331de55c8dfbbf71272d0d5088"

  url "https:github.comrxhansonRectanglereleasesdownloadv#{version}Rectangle#{version}.dmg",
      verified: "github.comrxhansonRectangle"
  name "Rectangle"
  desc "Move and resize windows using keyboard shortcuts or snap areas"
  homepage "https:rectangleapp.com"

  livecheck do
    url "https:rectangleapp.comdownloadsupdates.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Rectangle.app"

  uninstall quit: "com.knollsoft.Rectangle"

  zap trash: [
    "~LibraryApplication Scriptscom.knollsoft.RectangleLauncher",
    "~LibraryApplication SupportRectangle",
    "~LibraryCachescom.knollsoft.Rectangle",
    "~LibraryContainerscom.knollsoft.RectangleLauncher",
    "~LibraryHTTPStoragescom.knollsoft.Rectangle",
    "~LibraryPreferencescom.knollsoft.Rectangle.plist",
    "~LibraryWebKitcom.knollsoft.Rectangle",
  ]
end