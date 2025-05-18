cask "font-iosevka-ss06" do
  version "33.2.3"
  sha256 "d0bab6857a01cb68b973ef13a3873fb4eccf3f9466249c70983984d04f28cdf0"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end