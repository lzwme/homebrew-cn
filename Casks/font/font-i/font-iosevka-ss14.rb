cask "font-iosevka-ss14" do
  version "32.2.1"
  sha256 "3ac5c3f07c7b6f9e01e32006504e18febdeea18a0d9b061a425806c713f14792"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS14-#{version}.zip"
  name "Iosevka SS14"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS14.ttc"

  # No zap stanza required
end