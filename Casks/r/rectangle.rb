cask "rectangle" do
  version "0.86"
  sha256 "5142f9c5a667f8d0d0e55be5547f5139e9390054397f264b1ae6cb73fa90a9c2"

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