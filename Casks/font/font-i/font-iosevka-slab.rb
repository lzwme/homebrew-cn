cask "font-iosevka-slab" do
  version "34.2.0"
  sha256 "2959deb353feabacab3a7ddf4ee5b2063a33fa3102cfe4ff1f90a440d32a25d4"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSlab-#{version}.zip"
  name "Iosevka Slab"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSlab.ttc"

  # No zap stanza required
end