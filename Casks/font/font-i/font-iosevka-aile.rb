cask "font-iosevka-aile" do
  version "33.2.2"
  sha256 "0af50ed9541a3d173d02d565b7747a2291c2af4a8713a8130ad4cbf94430cc76"

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