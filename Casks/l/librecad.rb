cask "librecad" do
  version "2.2.1"
  sha256 "e3e13799cff6767f76e3716e72999f18eded6f008975d75dac650425f661c6fb"

  url "https:github.comLibreCADLibreCADreleasesdownloadv#{version}LibreCAD-v#{version}.dmg",
      verified: "github.comLibreCADLibreCAD"
  name "LibreCAD"
  desc "CAD application"
  homepage "https:librecad.org"

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