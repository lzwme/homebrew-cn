cask "font-iosevka-ss17" do
  version "34.2.0"
  sha256 "be15119d2d9cac3f1bd1d3e411ade93f960f3d4d1ffbfdf9074154ea7913bfe6"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17.ttc"

  # No zap stanza required
end