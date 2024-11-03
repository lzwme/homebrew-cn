cask "font-iosevka-aile" do
  version "32.0.0"
  sha256 "0cb5de1cccd19c99daa005b67ed4e26e66f0afcff6d3e4e86e8cbaef2d0e702d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end