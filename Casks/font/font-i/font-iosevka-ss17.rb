cask "font-iosevka-ss17" do
  version "32.0.1"
  sha256 "0bed8bbaae1903bc3b5eb52d14ae0e42c948efc3a67c06256efab6e9acc1247d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17.ttc"

  # No zap stanza required
end