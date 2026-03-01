cask "font-iosevka-curly" do
  version "34.2.0"
  sha256 "f1851ef579877612f622b517e6612f4a3f8dd69fc93f4d1e3ca4b4270b69abe6"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaCurly-#{version}.zip"
  name "Iosevka Curly"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurly.ttc"

  # No zap stanza required
end