cask "vcv-rack" do
  arch arm: "arm64", intel: "x64"

  version "2.5.1"
  sha256  arm:   "8b1515ca580a0ab69e7e9e16e82b5cf0f7cef4e107d7263d67d4e889604d8857",
          intel: "37ce22538553367953d43659d3246c9707f4c64876809a7828b66cc5900eab7d"

  url "https:vcvrack.comdownloadsRackFree-#{version}-mac-#{arch}.pkg"
  name "VCV Rack"
  desc "Open-source virtual modular synthesiser"
  homepage "https:vcvrack.com"

  livecheck do
    url "https:raw.githubusercontent.comVCVRackRackv#{version.major}CHANGELOG.md"
    regex(###\s(\d+(?:\.\d+)+)i)
  end

  pkg "RackFree-#{version}-mac-#{arch}.pkg"

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