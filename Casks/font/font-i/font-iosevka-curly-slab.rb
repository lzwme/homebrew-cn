cask "font-iosevka-curly-slab" do
  version "31.6.1"
  sha256 "b39658a3e15344de5e3879f9a4f8a27de404dc191ee7bfe0f06068bef09bacda"

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