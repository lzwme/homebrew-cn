cask "font-iosevka-ss18" do
  version "31.1.0"
  sha256 "acefa2b1979392188706c54665e798a1ab6cbfbff219588f6421ee051cf01fc7"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS18-#{version}.zip"
  name "Iosevka SS18"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS18.ttc"

  # No zap stanza required
end