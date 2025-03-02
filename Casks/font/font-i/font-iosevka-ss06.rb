cask "font-iosevka-ss06" do
  version "33.0.0"
  sha256 "496073f184382f0f6daa265bc12a9b62cb00123b5700dff421761a1fdf4b3d6b"

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