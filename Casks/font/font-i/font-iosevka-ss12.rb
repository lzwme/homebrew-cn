cask "font-iosevka-ss12" do
  version "33.1.0"
  sha256 "a00eb22874fd16d2a7ce86883cb62b667d85f1af4201294d42960946d893f2f8"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS12-#{version}.zip"
  name "Iosevka SS12"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS12.ttc"

  # No zap stanza required
end