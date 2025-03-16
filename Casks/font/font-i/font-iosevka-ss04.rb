cask "font-iosevka-ss04" do
  version "33.1.0"
  sha256 "c5a08ab695042073b15069e1437391a151315ee68e4a9555c5b25cf09b1c1a70"

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