cask "font-iosevka-ss01" do
  version "31.7.0"
  sha256 "e7fb9a8ce11872dea5e270732fe4e5322836951541e011725e03422792c70710"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end