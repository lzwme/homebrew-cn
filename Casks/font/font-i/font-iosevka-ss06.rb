cask "font-iosevka-ss06" do
  version "32.0.0"
  sha256 "e3192fd3c28cc3333939265c541c1f9f988390fc0a77e9cf625d503beaec8c23"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end