cask "font-iosevka-ss10" do
  version "31.2.0"
  sha256 "2f391f6b5bb4f787ff039a58c1fc0fec222d56017bcdebf4935052fdf4ee49b7"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10.ttc"

  # No zap stanza required
end