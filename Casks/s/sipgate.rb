cask "sipgate" do
  version "2.22.4"
  sha256 "97425c8b55ef2efca99a73e62e375b0dbba63711f100ded07461e18159608a68"

  url "https://s3-eu-central-1.amazonaws.com/desktop.download.sipgate.com/sipgate-#{version}.zip",
      verified: "s3-eu-central-1.amazonaws.com/desktop.download.sipgate.com/"
  name "sipgate"
  desc "Softphone for making telephone calls over the internet"
  homepage "https://www.sipgate.de/app"

  livecheck do
    url "https://s3-eu-central-1.amazonaws.com/desktop.download.sipgate.com/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "sipgate.app"

  zap trash: [
    "~/Library/Application Support/sipgate-desktop",
    "~/Library/Caches/com.sipgate.desktop",
    "~/Library/Caches/com.sipgate.desktop.ShipIt",
    "~/Library/Caches/sipgate-desktop-updater",
    "~/Library/HTTPStorages/com.sipgate.desktop",
    "~/Library/Logs/sipgate-desktop",
    "~/Library/Preferences/com.sipgate.desktop.plist",
    "~/Library/Saved Application State/com.sipgate.desktop.savedState",
  ]
end