cask "font-iosevka-ss12" do
  version "31.3.0"
  sha256 "9b3f406f3d285a677b8a78876c1ac0f4619acbd78bd0be2ac3114dd828cff81b"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS12-#{version}.zip"
  name "Iosevka SS12"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS12.ttc"

  # No zap stanza required
end