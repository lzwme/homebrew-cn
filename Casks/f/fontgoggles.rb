cask "fontgoggles" do
  version "1.8.3"
  sha256 "8a74c279dc17a14ed1c616b4fb313c2f75c6d5d7fb76060edebff751acf38e5c"

  url "https:github.comjustvanrossumfontgogglesreleasesdownloadv#{version}FontGoggles.dmg",
      verified: "github.comjustvanrossumfontgoggles"
  name "FontGoggles"
  desc "Font viewer for various font formats"
  homepage "https:fontgoggles.org"

  app "FontGoggles.app"

  zap trash: "~LibraryPreferencescom.github.justvanrossum.FontGoggles.plist"
end