cask "8bitdo-firmware-updater" do
  version "2.4.2"
  sha256 "71c1d6254f7dc1a2310b543dd034b2d82d0c6d06821b399625181f1f9aef2947"

  url "http://tools.8bitdo.com/8BitdoFirmwareUpdater/8BitDoFirmwareUpdaterV#{version}.zip"
  name "8BitDo Firmware Updater"
  desc "Firmware updater for 8BitDo devices"
  homepage "https://support.8bitdo.com/firmware-updater.html"

  livecheck do
    url "http://tools.8bitdo.com/8BitdoFirmwareUpdater/appcast.xml"
    strategy :sparkle
  end

  app "8BitDo Firmware Updater.app"

  uninstall quit: "com.Dev.Sihoo.-BitDoFirmwareUpdater"

  zap trash: [
    "~/Library/Caches/com.Dev.Sihoo.-BitDoFirmwareUpdater",
    "~/Library/Preferences/com.Dev.Sihoo.-BitDoFirmwareUpdater.plist",
    "~/Library/Saved Application State/com.Dev.Sihoo.-BitDoFirmwareUpdater.savedState",
  ]
end