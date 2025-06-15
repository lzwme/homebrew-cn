cask "librecad" do
  version "2.2.1.1"
  sha256 "76f8adbb4dbac5312e0c645f7127c3081ce3959b482488352a176a35f9154c0f"

  url "https:github.comLibreCADLibreCADreleasesdownloadv#{version}LibreCAD-v#{version}.dmg",
      verified: "github.comLibreCADLibreCAD"
  name "LibreCAD"
  desc "CAD application"
  homepage "https:librecad.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "LibreCAD.app"

  zap trash: [
    "~LibraryApplication SupportLibreCAD",
    "~LibraryPreferencescom.librecad.LibreCAD.plist",
    "~LibrarySaved Application Statecom.yourcompany.LibreCAD.savedstate",
  ]

  caveats do
    requires_rosetta
  end
end