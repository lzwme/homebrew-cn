cask "font-iosevka-ss02" do
  version "34.2.0"
  sha256 "8bc18c594716f8eebc405f9c05769c03cdcaed25426479e062ecd0a877552cad"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS02-#{version}.zip"
  name "Iosevka SS02"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS02.ttc"

  # No zap stanza required
end