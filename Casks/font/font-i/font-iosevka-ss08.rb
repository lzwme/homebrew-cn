cask "font-iosevka-ss08" do
  version "33.2.6"
  sha256 "43df361b83dcb45f0857640d225864b0dda242420e319992e6330134658980b1"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end