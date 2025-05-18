cask "font-iosevka-slab" do
  version "33.2.3"
  sha256 "db818a205f4b4e05c9a47b8ee094efaf1b73b9bd869f68cf2add214730beef0c"

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