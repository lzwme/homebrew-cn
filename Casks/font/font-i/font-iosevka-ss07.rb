cask "font-iosevka-ss07" do
  version "31.8.0"
  sha256 "510a0dad258194aadea85118c2e70284bff410774dc432d83cb88fb10a4cf2d8"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end