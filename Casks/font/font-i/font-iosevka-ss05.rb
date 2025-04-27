cask "font-iosevka-ss05" do
  version "33.2.2"
  sha256 "dcaab8c04496980f93afe6c7a93c1c471cff88699d06a59e12951874cbf02c11"

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