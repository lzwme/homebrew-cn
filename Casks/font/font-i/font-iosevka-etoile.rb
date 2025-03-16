cask "font-iosevka-etoile" do
  version "33.1.0"
  sha256 "a0824801ec7e23972739f1007ffdbd9c0ddb6860f9da3500186ab41417097c70"

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