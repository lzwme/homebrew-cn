cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "2.1.0"
  sha256 arm:   "0b7e752360dfe79e4272b812e5ba31f346fa2fdd4a120d90694313b217bd10e8",
         intel: "3d5ee8e535d7b01d1888bfa8b7a304e161ddc45d908b17b4cf234f7c7813cfbd"

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