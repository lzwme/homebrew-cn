cask "vcv-rack" do
  version "2.6.0"
  sha256 "8efe37947428e08dafc618674e97f0514ef73dcad8608584660b7899b5b91b55"

  url "https:vcvrack.comdownloadsRackFree-#{version}-mac-x64+arm64.pkg"
  name "VCV Rack"
  desc "Open-source virtual modular synthesiser"
  homepage "https:vcvrack.com"

  livecheck do
    url "https:raw.githubusercontent.comVCVRackRackv#{version.major}CHANGELOG.md"
    regex(###\s(\d+(?:\.\d+)+)i)
  end

  pkg "RackFree-#{version}-mac-x64+arm64.pkg"

  uninstall pkgutil: "com.vcvrack.rack"

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