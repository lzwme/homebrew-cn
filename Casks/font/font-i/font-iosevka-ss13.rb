cask "font-iosevka-ss13" do
  version "34.2.0"
  sha256 "3bdd4ad199823b985028c3b79436ba8529f936453e7e0fd6c30dedba4672d7ac"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end