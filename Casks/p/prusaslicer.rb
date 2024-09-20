cask "prusaslicer" do
  version "2.8.1,202409181403"
  sha256 "8a5e482a67ed674da66b26c84e93f3268e736b07e3ab7df4616c440074597cee"

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