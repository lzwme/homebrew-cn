cask "betaflight-configurator" do
  version "10.10.0"
  sha256 "a9ddadd2d983e62865cab7a3839f5a6513e3c839a0c4c3c79b5fa9730ed5a3bd"

  url "https://ghfast.top/https://github.com/betaflight/betaflight-configurator/releases/download/#{version}/betaflight-configurator_#{version}_macOS.dmg"
  name "Betaflight-Configurator"
  desc "Configuration tool for the Betaflight firmware"
  homepage "https://github.com/betaflight/betaflight-configurator"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Betaflight Configurator.app"

  zap trash: [
    "~/Library/Application Support/betaflight-configurator",
    "~/Library/Caches/betaflight-configurator",
    "~/Library/Preferences/com.nw-builder.betaflight-configurator.plist",
    "~/Library/Saved Application State/com.nw-builder.betaflight-configurator.savedState",
  ]

  caveats do
    requires_rosetta
  end
end