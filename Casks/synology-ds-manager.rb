cask "synology-ds-manager" do
  version "1.4.2"
  sha256 "bf851adbca4f1864cd914a52d3323f96ba3d9065cba29a39224d707736e97510"

  url "https:github.comnicerloopSynologyDSManagerreleasesdownload#{version}SynologyDSManager-#{version}.zip",
      verified: "github.comnicerloopSynologyDSManager"
  name "Synology DS Manager"
  desc "Synology Download Station application and Safari Extension"
  homepage "https:web.archive.orgweb20220812025146https:swiftapps.skavans.rusynology-ds-manager-mac"

  app "SynologyDSManager.app"

  zap trash: [
    "~LibraryApplication Scriptscom.skavans.synologyDSManager",
    "~LibraryApplication Scriptscom.skavans.synologyDSManager.extension",
    "~LibraryContainerscom.skavans.synologyDSManager",
    "~LibraryContainerscom.skavans.synologyDSManager.extension",
  ]
end