cask "font-iosevka-curly-slab" do
  version "31.7.1"
  sha256 "9596403176138140dba71bc6adf14168d528faa94b0b54a05454aff7b6c00b5a"

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