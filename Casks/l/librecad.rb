cask "librecad" do
  version "2.2.0.2"
  sha256 "552e2ac63fca297c617511c3983be7477bc050e8f774841abb7db5ce81ce935b"

  url "https:github.comLibreCADLibreCADreleasesdownload#{version}LibreCAD-#{version}.dmg",
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