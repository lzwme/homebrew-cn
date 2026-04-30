cask "nrf-connect" do
  arch arm: "arm64", intel: "x64"

  version "5.3.0"
  sha256 arm:   "529c2a12ed920fd10e8ea30d6a83cc4efaf91ea32f0af5829ac610afe77b9add",
         intel: "8854deef1ca54d25f1c015058a44931d0b58b291f49ec9a7949290e1588a10ed"

  url "https://ghfast.top/https://github.com/NordicSemiconductor/pc-nrfconnect-launcher/releases/download/v#{version}/nrfconnect-#{version}-#{arch}.dmg",
      verified: "github.com/NordicSemiconductor/pc-nrfconnect-launcher/"
  name "nRF Connect for Desktop"
  desc "Framework for development on BLE devices"
  homepage "https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-Desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "nRF Connect for Desktop.app"

  zap trash: [
    "~/.nrfconnect-apps",
    "~/Library/Application Support/nrfconnect",
    "~/Library/Preferences/com.nordicsemi.nrfconnect.plist",
    "~/Library/Saved Application State/com.nordicsemi.nrfconnect.savedState",
  ]
end