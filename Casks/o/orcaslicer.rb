cask "orcaslicer" do
  arch arm: "arm64", intel: "x86_64"

  version "1.8.1"
  sha256 arm:   "9743db8ad3ec2203b685afca588e9c7176804939cc66960f8ef7790f5d773793",
         intel: "7e5f5826902b39e68d8d4bf94b5e12000527b857d1cc6f561326c33aaeb425b3"

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