cask "font-iosevka-slab" do
  version "31.7.1"
  sha256 "7738ba3952e1a43d94827f9ef88c1123350c61dc957cf62edf36edbe34056e95"

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