cask "font-iosevka-ss07" do
  version "31.2.0"
  sha256 "563b92ae66bbb44b5b53db040170da10d2d03ca0965ed1f6bd626681cea0bffa"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end