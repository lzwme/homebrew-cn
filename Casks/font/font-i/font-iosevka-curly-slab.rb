cask "font-iosevka-curly-slab" do
  version "33.2.3"
  sha256 "6dff4ff8a55155586ee314b4ce1bd24396a7d6c4027c02e2e56103fbe25fee42"

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