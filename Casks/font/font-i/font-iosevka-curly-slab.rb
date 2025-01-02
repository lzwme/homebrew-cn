cask "font-iosevka-curly-slab" do
  version "32.3.1"
  sha256 "9638dc8c2d3a79a4fddafd2da35c45352cbaffa432b28594b9777223f3a03f29"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaCurlySlab-#{version}.zip"
  name "Iosevka Curly Slab"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurlySlab.ttc"

  # No zap stanza required
end