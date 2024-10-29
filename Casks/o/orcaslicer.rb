cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "2.2.0"
  sha256 arm:   "8f041d83c71af3dbae10806ccde9472e12d479c6b08b5224b6b44bac5896247e",
         intel: "db639a1c97907d639dfff2edc4d19a24bc38b96f8a4677cb94441736ce48b907"

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