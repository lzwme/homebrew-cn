cask "font-iosevka-ss04" do
  version "32.0.0"
  sha256 "6db72df382fdd39c52bfcadd4f66cf30f144fb6a7671aa042ede540f0601b65e"

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