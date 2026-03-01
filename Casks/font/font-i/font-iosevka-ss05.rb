cask "font-iosevka-ss05" do
  version "34.2.0"
  sha256 "e0c1539b52151e7286383061b3f89dfd15343d83e5b85125030181570488ef25"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end