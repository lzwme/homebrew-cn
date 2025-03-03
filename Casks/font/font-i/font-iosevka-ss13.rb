cask "font-iosevka-ss13" do
  version "33.0.1"
  sha256 "efbca6bb71fc6877745854eabd29445e93daefbdad10e05628f4b3ef6bb36e7b"

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