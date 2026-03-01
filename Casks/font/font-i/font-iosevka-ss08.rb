cask "font-iosevka-ss08" do
  version "34.2.0"
  sha256 "26d2edd243279325b2f015610777cf91131c76a83b5b1d686c61b4343218af21"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end