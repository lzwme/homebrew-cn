cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "1.9.1"
  sha256 arm:   "28db87f6554aec0d4297ba4b7d12a3bf93bd90964e22245483d7239d1f967ecc",
         intel: "0dc96b0b53ae9b7d09956fde812436302dcc01db7757b25ee6b552597911ed47"

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