cask "font-iosevka-curly" do
  version "32.3.0"
  sha256 "ff6f431f45479ec37553505f0c94c4a48c4096dc4cc50ed65b2f5dc8943276dc"

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