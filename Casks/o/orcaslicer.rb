cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.0"
  sha256 arm:   "3af72e3c47b9989e77a56af9464a6904a9bfbba7251f881d94c6ae9b27ec0c8b",
         intel: "5db95e189449a07850fed3d2535b9886c283712a639cd12d7e5cedca7049e75b"

  url "https:github.comSoftFeverOrcaSlicerreleasesdownloadv#{version}OrcaSlicer_Mac_#{arch}_V#{version}.dmg"
  name "Orca Slicer"
  desc "G-code generator for 3D printers"
  homepage "https:github.comSoftFeverOrcaSlicer"

  app "OrcaSlicer.app"

  zap trash: [
    "~LibraryApplication SupportOrcaSlicer",
    "~LibraryCachescom.softfever3d.orca-slicer",
    "~LibraryHTTPStoragescom.softfever3d.orcaslicer.binarycookies",
    "~LibraryPreferencescom.softfever3d.orca-slicer.plist",
    "~LibrarySaved Application Statecom.softfever3d.orca-slicer.savedState",
    "~LibraryWebKitcom.softfever3d.orca-slicer",
  ]
end