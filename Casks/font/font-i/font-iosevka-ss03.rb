cask "font-iosevka-ss03" do
  version "34.2.0"
  sha256 "74e57745ad88e66c12dcb3a89ae972d2a9828f7d8347dc997b35c52b46cfbbd1"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS03-#{version}.zip"
  name "Iosevka SS03"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS03.ttc"

  # No zap stanza required
end