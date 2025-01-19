cask "font-iosevka-ss02" do
  version "32.4.0"
  sha256 "ad27f98eebc938412c9fdbaead80068fe5d35be95d106609c95a6726a0fa518e"

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