cask "vcv-rack" do
  arch arm: "arm64", intel: "x64"

  version "2.5.0"
  sha256  arm:   "7ae70918e85967f1468252209e52341d8c538c43ad7a2e2b84b3099aeb27039b",
          intel: "afdb0271362fa14bda34a9a21a20ceb3ee8d3e555d684ba341cc3dfef10058b4"

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