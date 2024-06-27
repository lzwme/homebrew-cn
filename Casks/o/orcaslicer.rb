cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "2.1.1"
  sha256 arm:   "3dab4044551b962d9d0e08fe9d78c8898ca26b2dad3cb4b2b342338098a47dad",
         intel: "bd7ce4528fd9568663d37987454d1bc79d2ee71f831455d63a46956f1a9b7893"

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