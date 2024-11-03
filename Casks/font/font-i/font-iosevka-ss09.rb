cask "font-iosevka-ss09" do
  version "32.0.0"
  sha256 "fe4061843ae1778691996dae7d3a4c2e774705a51d1c3b53e9a8f6c71db8f4ab"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS09-#{version}.zip"
  name "Iosevka SS09"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS09.ttc"

  # No zap stanza required
end