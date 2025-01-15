cask "fontgoggles" do
  version "1.8.5"
  sha256 "e23736fb0bb9907e83ba9b099ff827c4017425da7e84ac80329f0fe0a3c450c9"

  url "https:github.comjustvanrossumfontgogglesreleasesdownloadv#{version}FontGoggles.dmg",
      verified: "github.comjustvanrossumfontgoggles"
  name "FontGoggles"
  desc "Font viewer for various font formats"
  homepage "https:fontgoggles.org"

  app "FontGoggles.app"

  zap trash: "~LibraryPreferencescom.github.justvanrossum.FontGoggles.plist"
end