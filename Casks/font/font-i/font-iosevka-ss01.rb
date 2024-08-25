cask "font-iosevka-ss01" do
  version "31.4.0"
  sha256 "4c3f477bafc2c1d340ecaff8d723a64be3a0cc016957e4385e7392215b9a714e"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end