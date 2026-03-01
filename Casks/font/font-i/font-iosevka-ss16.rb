cask "font-iosevka-ss16" do
  version "34.2.0"
  sha256 "7287ea6f2f7eb496a36bbd9695c368b8c9bfdd9bef8459f6c385cf0d69abe6e4"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS16-#{version}.zip"
  name "Iosevka SS16"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS16.ttc"

  # No zap stanza required
end