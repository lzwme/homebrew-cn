cask "font-iosevka-etoile" do
  version "31.6.0"
  sha256 "5812eb21de1b92f6c573a4d6b67871587a797aedea16409fd0fb89f985e5bb60"

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