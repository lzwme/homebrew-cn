cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "1.9.0"
  sha256 arm:   "08d0ed089fdb88c6b7f049828a355cbb1419a30ef2c9318fa12d2a9186782380",
         intel: "3246b04e8b139cdc8dc682ea1b490f7d67bb200226a5a2f5cb8fa43a5c313c8e"

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