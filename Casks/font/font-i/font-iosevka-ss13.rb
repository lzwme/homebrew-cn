cask "font-iosevka-ss13" do
  version "33.0.0"
  sha256 "ff3f0dab87ce4e1d3955fe9d359a03e1e7e0194f55319f0e9677ed34f08ba0a4"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end