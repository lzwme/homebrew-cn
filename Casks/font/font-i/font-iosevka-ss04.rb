cask "font-iosevka-ss04" do
  version "33.2.6"
  sha256 "265a71b2dcd753226993c681777e755eaff78ac3d92907c0dfc8ea5cd9a189fd"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04.ttc"

  # No zap stanza required
end