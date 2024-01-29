cask "synology-ds-manager" do
  version "1.4.2"
  sha256 "53cd78b6295e5405fb87ef27e199193392eecb55b67ae3e1facf8da1a7b20e72"

  url "https:github.comskavansSynologyDSManagerreleasesdownloadv#{version}SynologyDSManager.zip"
  name "Synology DS Manager"
  desc "Synology Download Station application and Safari Extension"
  homepage "https:github.comskavansSynologyDSManager"

  app "SynologyDSManager.app"

  zap trash: [
    "~LibraryApplication Scriptscom.skavans.synologyDSManager",
    "~LibraryApplication Scriptscom.skavans.synologyDSManager.extension",
    "~LibraryContainerscom.skavans.synologyDSManager",
    "~LibraryContainerscom.skavans.synologyDSManager.extension",
  ]
end