cask "font-iosevka-ss14" do
  version "31.6.1"
  sha256 "87a7dfb6170808d146a661982ec4913adada072987a36f83e1f50e652945401a"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS14-#{version}.zip"
  name "Iosevka SS14"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS14.ttc"

  # No zap stanza required
end