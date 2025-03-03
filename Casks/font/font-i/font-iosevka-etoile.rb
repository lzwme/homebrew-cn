cask "font-iosevka-etoile" do
  version "33.0.1"
  sha256 "accbe32c1bae02d24ef03de7ebda72f11c70f2496ee672f4b8edd684b64fde45"

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