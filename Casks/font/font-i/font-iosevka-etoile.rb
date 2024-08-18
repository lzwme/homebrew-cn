cask "font-iosevka-etoile" do
  version "31.3.0"
  sha256 "3525cd0dc8c27af171b4583e5c4c56ee6e917a1a697ade83e447714ac432b5f0"

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