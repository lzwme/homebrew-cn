cask "font-iosevka-curly-slab" do
  version "33.2.4"
  sha256 "5028705a445810752d2f1746e798478f5794ecf4071a887984b519a4ce55976b"

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