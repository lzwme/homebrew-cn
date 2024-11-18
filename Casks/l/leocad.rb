cask "leocad" do
  version "23.03"
  sha256 "7ee537139760b1938980435a3d32bd8068d5e7437e310a01a1f7fd8cf6565867"

  url "https:github.comleozideleocadreleasesdownloadv#{version}LeoCAD-macOS-#{version}.dmg"
  name "LeoCAD"
  desc "CAD program for creating virtual LEGO models"
  homepage "https:github.comleozideleocad"

  depends_on macos: ">= :sierra"

  app "LeoCAD.app"

  zap trash: [
    "~LibraryCachesLeoCAD Software",
    "~LibraryPreferencesorg.leocad.LeoCAD.plist",
    "~LibrarySaved Application Stateorg.leozide.LeoCAD.savedState",
  ]

  caveats do
    requires_rosetta
  end
end