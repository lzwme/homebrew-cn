cask "font-iosevka-ss04" do
  version "32.1.0"
  sha256 "21e0a19258426c33dd7c96adfc4a79993bf83799a982aee7e1249c9703b33feb"

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