cask "synology-ds-manager" do
  version "1.4.2"
  sha256 "53cd78b6295e5405fb87ef27e199193392eecb55b67ae3e1facf8da1a7b20e72"

  url "https://ghfast.top/https://github.com/skavans/SynologyDSManager/releases/download/v#{version}/SynologyDSManager.zip"
  name "Synology DS Manager"
  desc "Synology Download Station application and Safari Extension"
  homepage "https://github.com/skavans/SynologyDSManager"

  app "SynologyDSManager.app"

  zap trash: [
    "~/Library/Application Scripts/com.skavans.synologyDSManager",
    "~/Library/Application Scripts/com.skavans.synologyDSManager.extension",
    "~/Library/Containers/com.skavans.synologyDSManager",
    "~/Library/Containers/com.skavans.synologyDSManager.extension",
  ]
end