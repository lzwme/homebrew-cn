cask "font-iosevka-ss13" do
  version "32.1.0"
  sha256 "c1db4cfa9752ae7fe6aa354359536b2c7cc54cc739d772ac7b8aec0d90777b74"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end