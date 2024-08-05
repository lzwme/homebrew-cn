cask "font-iosevka-slab" do
  version "31.1.0"
  sha256 "54c0e77440e9a47d011a2eb92ed1eba20972a6a919bc21960e8553d44db0086a"

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