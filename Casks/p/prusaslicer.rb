cask "prusaslicer" do
  version "2.7.1,202312121432"
  sha256 "208f6669d44b8bb19089eea54b67ac056eb13469fd008d6fa0475e18ba0d857f"

  url "https:github.comprusa3dPrusaSlicerreleasesdownloadversion_#{version.csv.first}PrusaSlicer-#{version.csv.first}+MacOS-universal-#{version.csv.second}.dmg",
      verified: "github.comprusa3dPrusaSlicer"
  name "PrusaSlicer"
  desc "G-code generator for 3D printers (RepRap, Makerbot, Ultimaker etc.)"
  homepage "https:www.prusa3d.comslic3r-prusa-edition"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "PrusaSlicer.app"

  zap trash: [
    "~LibraryApplication SupportPrusaSlicer",
    "~LibraryPreferencescom.prusa3d.slic3r",
    "~LibrarySaved Application Statecom.prusa3d.slic3r.savedState",
  ]
end