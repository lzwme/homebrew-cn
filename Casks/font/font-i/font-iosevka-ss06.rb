cask "font-iosevka-ss06" do
  version "31.6.1"
  sha256 "3adbcc808483db0529ec9eb880adf0ac49172b4c0d10cf381320a8b2afcd590a"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end