cask "fontgoggles" do
  version "1.8"
  sha256 "383e71acac89a442e279596f141bf2b86fdcd6ef93f651d2e20d5219dc365e23"

  url "https:github.comjustvanrossumfontgogglesreleasesdownloadv#{version}FontGoggles.dmg",
      verified: "github.comjustvanrossumfontgoggles"
  name "FontGoggles"
  desc "Font viewer for various font formats"
  homepage "https:fontgoggles.org"

  app "FontGoggles.app"

  zap trash: "~LibraryPreferencescom.github.justvanrossum.FontGoggles.plist"
end