cask "font-iosevka-ss14" do
  version "31.6.0"
  sha256 "365067944153890e1a8da42b070a1698503c21442af403bb8e1448e7f5bcadc6"

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