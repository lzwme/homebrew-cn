cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "2.3.0"
  sha256 arm:   "6d040fc8f72f0553746b73bd7f676e4c3ecd7dded5bfce74817670fce6f2edb6",
         intel: "1b64454a2219aa1a9391e34121e948f32e6b200ea3044faa666d0768bf0f26e6"

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