cask "font-iosevka-ss01" do
  version "33.2.0"
  sha256 "2e1d5c4bcd2cfb03a9ddbd911cd2fcc6af4b33ee5af926c848be56f8db96c528"

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