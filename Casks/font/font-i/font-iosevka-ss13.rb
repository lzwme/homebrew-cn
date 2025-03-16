cask "font-iosevka-ss13" do
  version "33.1.0"
  sha256 "5173df0080b2af4e571b1ef1ee321346b0013f3da1428fb673707e5520fbd7ce"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end