cask "font-iosevka-ss04" do
  version "33.2.3"
  sha256 "0fa341ba7574098dc3ee03cbf6a12d606c526fad37c286cacd70a78e899766b3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04.ttc"

  # No zap stanza required
end