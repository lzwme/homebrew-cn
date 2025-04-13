cask "font-iosevka-ss04" do
  version "33.2.1"
  sha256 "88646e3b066390de675b6e54fec9b9ec615af25acbbb42edc5fca192c61c687c"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04.ttc"

  # No zap stanza required
end