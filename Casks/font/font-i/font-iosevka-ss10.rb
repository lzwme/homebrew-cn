cask "font-iosevka-ss10" do
  version "33.2.6"
  sha256 "2cddb861f610dbc68273e830f414fc4b4d215361b0871e5598713668da77d339"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10.ttc"

  # No zap stanza required
end