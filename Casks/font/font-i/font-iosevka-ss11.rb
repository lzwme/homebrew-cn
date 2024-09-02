cask "font-iosevka-ss11" do
  version "31.5.0"
  sha256 "61779d33fc6de1761d62622444bf6dd48d2c5bcdc15eceffda9167a500508209"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS11-#{version}.zip"
  name "Iosevka SS11"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS11.ttc"

  # No zap stanza required
end