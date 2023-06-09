cask "synology-ds-manager" do
  version "1.4.2"
  sha256 "bf851adbca4f1864cd914a52d3323f96ba3d9065cba29a39224d707736e97510"

  url "https://ghproxy.com/https://github.com/nicerloop/SynologyDSManager/releases/download/#{version}/SynologyDSManager-#{version}.zip"
  name "Synology DS Manager"
  desc "Synology Download Station application and Safari Extension"
  homepage "https://web.archive.org/web/20220812025146/https://swiftapps.skavans.ru/synology-ds-manager-mac/"

  app "SynologyDSManager.app"

  zap trash: [
    "~/Library/Application Scripts/com.skavans.synologyDSManager",
    "~/Library/Application Scripts/com.skavans.synologyDSManager.extension",
    "~/Library/Containers/com.skavans.synologyDSManager",
    "~/Library/Containers/com.skavans.synologyDSManager.extension",
  ]
end