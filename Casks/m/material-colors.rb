cask "material-colors" do
  version "2.0.3"
  sha256 "601465d533d93399c89fa2a135dba8d936cca239ff601d20195c44244a64053a"

  url "https:github.comromannurikMaterialColorsAppreleasesdownloadv#{version}MaterialColors-#{version}.zip"
  name "Material Colors for Mac"
  homepage "https:github.comromannurikMaterialColorsApp"

  app "Material Colors.app"

  zap trash: [
    "~LibraryApplication Supportnet.nurik.roman.materialcolors.ShipIt",
    "~LibraryApplication SupportMaterial Colors",
    "~LibraryCachesMaterial Colors",
    "~LibraryCachesnet.nurik.roman.materialcolors",
    "~LibraryPreferencesnet.nurik.roman.materialcolors.plist",
  ]
end