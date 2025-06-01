cask "font-iosevka-slab" do
  version "33.2.4"
  sha256 "18cae71b5b62d671bc5a71b7c962c3feff6c558165aee346a3e06f54efeaf247"

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