cask "prusaslicer" do
  version "2.7.2,202402291330"
  sha256 "70c6225c42e7ec0ba104375a986e8167fcdf2ee074dec648b8daf4fc467ff279"

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