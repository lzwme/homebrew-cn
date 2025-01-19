cask "font-iosevka-curly-slab" do
  version "32.4.0"
  sha256 "6c0e4712ce2f83da78ff78dc016f66897e12e5ee5723e7c84c9a4e789725a129"

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