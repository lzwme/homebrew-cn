cask "rectangle" do
  version "0.83"
  sha256 "477eb89b55f4350932fd6f4dceccd4ccffb67f4e99a81b892a1e66dae3972e6a"

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