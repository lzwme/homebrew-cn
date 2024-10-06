cask "font-iosevka-ss02" do
  version "31.8.0"
  sha256 "bf889bef1c62c719c2cc3aa2842d0730df12175000d0a61d1eb6b1b989b8ee93"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS02-#{version}.zip"
  name "Iosevka SS02"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS02.ttc"

  # No zap stanza required
end