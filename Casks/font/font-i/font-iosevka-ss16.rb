cask "font-iosevka-ss16" do
  version "32.3.1"
  sha256 "5fb5a720c7bd3e29f58d1ea561cdc70292e8825b6dceca6c9996d8d65021c5b1"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS16-#{version}.zip"
  name "Iosevka SS16"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS16.ttc"

  # No zap stanza required
end