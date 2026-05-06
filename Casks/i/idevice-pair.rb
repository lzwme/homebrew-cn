cask "idevice-pair" do
  version "0.1.12"
  sha256 "11fdc7b6ee0f48e34503c7d4451444142eff69fec62be6e374470d5d2e76ff09"

  url "https://ghfast.top/https://github.com/jkcoxson/idevice_pair/releases/download/#{version}/idevice_pair--macos-universal.dmg"
  name "idevice_pair"
  desc "Generate pair records for iOS devices"
  homepage "https://github.com/jkcoxson/idevice_pair"

  depends_on macos: ">= :big_sur"

  app "idevice_pair.app"

  # No zap stanza required
end