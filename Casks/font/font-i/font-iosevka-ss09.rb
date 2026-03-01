cask "font-iosevka-ss09" do
  version "34.2.0"
  sha256 "016c62c37b52eacdfe5bfbedbe90e2133751d08756f5ca212afe031abec0a14f"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS09-#{version}.zip"
  name "Iosevka SS09"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS09.ttc"

  # No zap stanza required
end