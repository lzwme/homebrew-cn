cask "fontgoggles" do
  version "1.8.7"
  sha256 "9361416c311455a02e9ddb36b6dac3cc06469282f4ef0ee40c12af7522bb6cb8"

  url "https:github.comjustvanrossumfontgogglesreleasesdownloadv#{version}FontGoggles.dmg",
      verified: "github.comjustvanrossumfontgoggles"
  name "FontGoggles"
  desc "Font viewer for various font formats"
  homepage "https:fontgoggles.org"

  app "FontGoggles.app"

  zap trash: "~LibraryPreferencescom.github.justvanrossum.FontGoggles.plist"
end