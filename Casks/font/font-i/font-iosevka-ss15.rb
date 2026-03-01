cask "font-iosevka-ss15" do
  version "34.2.0"
  sha256 "eacf83c1f74e0d4a3c1ecff17fb264ae5f6d5092bac405f8af02e1010ca2c198"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS15-#{version}.zip"
  name "Iosevka SS15"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS15.ttc"

  # No zap stanza required
end