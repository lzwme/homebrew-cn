cask "font-iosevka-ss01" do
  version "33.2.1"
  sha256 "d515468735d0cf8ed840b139f367157246304d4442e3b34d6153324964ed276c"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end