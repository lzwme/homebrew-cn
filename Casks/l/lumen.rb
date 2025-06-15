cask "lumen" do
  version "1.2.2"
  sha256 "608321c996b736b931b9048c85268bc95ec96ebeb40d329cd73656daac4cb440"

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