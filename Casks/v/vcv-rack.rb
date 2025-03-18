cask "vcv-rack" do
  version "2.6.2"
  sha256 "c880dbfac23c1e1d4562442dd3f479caacee90456f24780df96211de54064157"

  url "https:vcvrack.comdownloadsRackFree-#{version}-mac-x64+arm64.pkg"
  name "VCV Rack"
  desc "Open-source virtual modular synthesiser"
  homepage "https:vcvrack.com"

  livecheck do
    url "https:raw.githubusercontent.comVCVRackRackv#{version.major}CHANGELOG.md"
    regex(###\s(\d+(?:\.\d+)+)i)
  end

  pkg "RackFree-#{version}-mac-x64+arm64.pkg"

  uninstall pkgutil: "com.vcvrack.rack*"

  zap trash: [
    "~DocumentsRack2*.json",
    "~DocumentsRack2autosave",
    "~DocumentsRack2log.txt",
    "~DocumentsRack2plugins-mac-arm64",
    "~DocumentsRack2plugins-mac-x64",
    "~LibraryApplication SupportRack2*.json",
    "~LibraryApplication SupportRack2autosave",
    "~LibraryApplication SupportRack2log.txt",
    "~LibraryApplication SupportRack2plugins-mac-arm64",
    "~LibraryApplication SupportRack2plugins-mac-x64",
  ]
end