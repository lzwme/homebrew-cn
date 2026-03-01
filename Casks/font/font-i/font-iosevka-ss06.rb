cask "font-iosevka-ss06" do
  version "34.2.0"
  sha256 "dfa689921c46046052a3ad2212f585d41b73ff5b5f53b2424fa0f77a64bbbe15"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end