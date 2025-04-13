cask "font-iosevka-slab" do
  version "33.2.1"
  sha256 "fa6e7b54f5576ee61362638f0ef219c2d59462d08c413006367b26c42931836d"

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