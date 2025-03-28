cask "vcv-rack" do
  version "2.6.3"
  sha256 "211fd84eab60e190c82dc0aa1509ef86cad5dd392afd17d6c5b866fc8f12ff3b"

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