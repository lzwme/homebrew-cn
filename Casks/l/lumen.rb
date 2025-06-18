cask "lumen" do
  version "1.3.0"
  sha256 "354cc6f83728a4bb4d2d469195afe7abcc5160ea1ca915ec84aee72c7907cd52"

  url "https:github.comanishathalyelumenreleasesdownloadv#{version}Lumen.zip"
  name "Lumen"
  desc "Magic auto brightness based on screen contents"
  homepage "https:github.comanishathalyelumen"

  no_autobump! because: :requires_manual_review

  app "Lumen.app"

  zap trash: [
    "~LibraryCachescom.anishathalye.Lumen",
    "~LibraryPreferencescom.anishathalye.Lumen.plist",
  ]
end