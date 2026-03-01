cask "font-iosevka-ss11" do
  version "34.2.0"
  sha256 "9f212b2c1591f8a059c4422da6563f057d6f50f79818caf332e0a431058edf71"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS11-#{version}.zip"
  name "Iosevka SS11"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS11.ttc"

  # No zap stanza required
end