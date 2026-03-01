cask "font-iosevka-ss04" do
  version "34.2.0"
  sha256 "104c895f7470eaa47ec09ea7fbe3e399198282b47f1b656c6930f067918095ff"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04.ttc"

  # No zap stanza required
end