cask "font-iosevka-slab" do
  version "31.7.0"
  sha256 "107355f73de8c0747b5339e5c0c84b838750c8d3ed351105124e7c058f849175"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSlab-#{version}.zip"
  name "Iosevka Slab"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSlab.ttc"

  # No zap stanza required
end