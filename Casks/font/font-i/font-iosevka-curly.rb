cask "font-iosevka-curly" do
  version "32.3.1"
  sha256 "f0ac3331797740456982bb2ace7943ec7d6d2a61fa934005cd870b0a1451b789"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaCurly-#{version}.zip"
  name "Iosevka Curly"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurly.ttc"

  # No zap stanza required
end