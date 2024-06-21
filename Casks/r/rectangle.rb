cask "rectangle" do
  version "0.80"
  sha256 "0a66213271219f750af36457b93d4a4210282bfd1ec1c514ea1ef77a5d8ba70f"

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