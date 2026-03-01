cask "font-iosevka-ss10" do
  version "34.2.0"
  sha256 "e8b4d36c588aaf7d21dd46c490f174b44031dac3999c6d7d61b52e083d93c53b"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10.ttc"

  # No zap stanza required
end