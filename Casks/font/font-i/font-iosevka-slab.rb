cask "font-iosevka-slab" do
  version "31.3.0"
  sha256 "55beda3d58ebd31357ec3eec19da65b12204452620e695750300ffee035ac865"

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