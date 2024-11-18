cask "font-iosevka-curly-slab" do
  version "32.1.0"
  sha256 "768a0a009bfcfef2299379b1225e5c01e019f9a7b9c06aa157e03c1c01a8621f"

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