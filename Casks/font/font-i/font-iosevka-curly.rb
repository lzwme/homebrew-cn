cask "font-iosevka-curly" do
  version "31.1.0"
  sha256 "c28513e30aa4687d5d3eff8126f3294c43645618a0fb1a8a433bcce6af3fc4da"

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