cask "font-iosevka-ss05" do
  version "33.2.3"
  sha256 "961180696754815044522a8d029fd3538c1befc0bb1cb479d592f1453302e520"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end