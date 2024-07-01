cask "vnote" do
  version "3.17.0"
  sha256 "7adeaf277dba716a8b6eb300b803d55e84a5e93ba34dcf6497b2680b1834bef2"

  url "https:github.comvnotexvnotereleasesdownloadv#{version}vnote-mac-x64-qt5.15.2_v#{version}.zip",
      verified: "github.comvnotexvnote"
  name "VNote"
  desc "Note-taking platform"
  homepage "https:vnotex.github.iovnote"

  app "VNote.app"

  zap trash: [
    "~LibraryApplication SupportVNote",
    "~LibraryPreferencescom.vnotex.vnote.plist",
    "~LibraryPreferencesVNote",
  ]

  caveats do
    requires_rosetta
  end
end