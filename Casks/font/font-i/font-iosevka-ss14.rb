cask "font-iosevka-ss14" do
  version "31.9.0"
  sha256 "0e826a08d20589028cb4ee3f178ea53d5b0d320027bb7d154fb23ce046829879"

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