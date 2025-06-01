cask "font-iosevka-etoile" do
  version "33.2.4"
  sha256 "e380d08233266b09a68d1924cada552383a8b398dd5c027b5b9f415e09e0fcda"

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