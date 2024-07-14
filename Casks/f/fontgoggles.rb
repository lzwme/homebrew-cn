cask "fontgoggles" do
  version "1.8.1"
  sha256 "7a8b34b9aa8b6e650baa2ed44900f1e85142a747893472d2b5aa2fa114a66624"

  url "https:github.comjustvanrossumfontgogglesreleasesdownloadv#{version}FontGoggles.dmg",
      verified: "github.comjustvanrossumfontgoggles"
  name "FontGoggles"
  desc "Font viewer for various font formats"
  homepage "https:fontgoggles.org"

  app "FontGoggles.app"

  zap trash: "~LibraryPreferencescom.github.justvanrossum.FontGoggles.plist"
end