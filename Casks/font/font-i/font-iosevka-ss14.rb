cask "font-iosevka-ss14" do
  version "34.2.0"
  sha256 "98e2d275e24a57dff90592c28c42cd6b0e9e35a05973e81dd118231721302b85"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS14-#{version}.zip"
  name "Iosevka SS14"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS14.ttc"

  # No zap stanza required
end