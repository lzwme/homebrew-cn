cask "font-iosevka-etoile" do
  version "32.0.0"
  sha256 "30e16569a53fac8df32339901ac8644e6f2c92806c8ed8dd94f2c9fd5f19b4cc"

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