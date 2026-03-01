cask "font-iosevka-ss07" do
  version "34.2.0"
  sha256 "859ac5cb02c5ba39c1bbbb80878c8e7a1c8c967434632b1a3898666f1f43b3e0"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end