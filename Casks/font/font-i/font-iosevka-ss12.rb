cask "font-iosevka-ss12" do
  version "34.2.0"
  sha256 "01ab09715a00e22b7f8fb1cb62b11463342d68644ab5349cfc6278d19db52edd"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS12-#{version}.zip"
  name "Iosevka SS12"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS12.ttc"

  # No zap stanza required
end