cask "rectangle" do
  version "0.87"
  sha256 "a275f345152faf75a2567f4967154ba9715c0a6146feed67fa83ac4c440c8bef"

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
  depends_on macos: ">= :catalina"

  app "Rectangle.app"

  uninstall quit:       "com.knollsoft.Rectangle",
            login_item: "Rectangle"

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