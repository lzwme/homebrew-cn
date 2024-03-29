cask "prusaslicer" do
  version "2.7.3,202403280951"
  sha256 "de3672ccfcba0ed8d8f36e989b0e66346eb99b9c42b1a0ebd5fd1a2f39b90207"

  url "https:github.comprusa3dPrusaSlicerreleasesdownloadversion_#{version.csv.first}PrusaSlicer-#{version.csv.first}+MacOS-universal-#{version.csv.second}.dmg",
      verified: "github.comprusa3dPrusaSlicer"
  name "PrusaSlicer"
  desc "G-code generator for 3D printers (RepRap, Makerbot, Ultimaker etc.)"
  homepage "https:www.prusa3d.comslic3r-prusa-edition"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "Original Prusa DriversPrusaSlicer.app"

  zap trash: [
    "~LibraryApplication SupportPrusaSlicer",
    "~LibraryPreferencescom.prusa3d.slic3r",
    "~LibrarySaved Application Statecom.prusa3d.slic3r.savedState",
  ]
end