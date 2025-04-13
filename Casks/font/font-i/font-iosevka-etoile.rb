cask "font-iosevka-etoile" do
  version "33.2.1"
  sha256 "a184c4dfd482d4999713c7df29ddd826aa08fbb7a932aa5201b7a6f5288d6148"

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