cask "font-iosevka-etoile" do
  version "33.2.5"
  sha256 "88d324ad93bdbd563005f6d3cffc72350a622078da8ccefe362c705cda5d973e"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaEtoile-#{version}.zip"
  name "Iosevka Etoile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaEtoile.ttc"

  # No zap stanza required
end