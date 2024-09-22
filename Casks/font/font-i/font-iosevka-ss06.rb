cask "font-iosevka-ss06" do
  version "31.7.0"
  sha256 "356a5f7928ebe2ecf509e652cc4ed0ccfbd8ae1656fdf9f41475bb974afa66b3"

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