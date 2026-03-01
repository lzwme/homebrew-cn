cask "font-iosevka-ss01" do
  version "34.2.0"
  sha256 "5c0006778a72d1b5ca7924cc7a2c8c46e7c4734f950d1cf767ccd128e61fbdd4"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end