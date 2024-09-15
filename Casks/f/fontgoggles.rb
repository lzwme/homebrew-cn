cask "fontgoggles" do
  version "1.8.2"
  sha256 "d4fec0a0c03f56fe75557d996cbef022244e93e0da5670b3651c3f6aa919504f"

  url "https:github.comjustvanrossumfontgogglesreleasesdownloadv#{version}FontGoggles.dmg",
      verified: "github.comjustvanrossumfontgoggles"
  name "FontGoggles"
  desc "Font viewer for various font formats"
  homepage "https:fontgoggles.org"

  app "FontGoggles.app"

  zap trash: "~LibraryPreferencescom.github.justvanrossum.FontGoggles.plist"
end