cask "prusaslicer" do
  version "2.8.0,202406270936"
  sha256 "42963067a3f2d5d302d237c648d84b64c4320fa0ca5613a29d2a505d7b9e5a49"

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