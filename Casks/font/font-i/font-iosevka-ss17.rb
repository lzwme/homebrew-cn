cask "font-iosevka-ss17" do
  version "31.1.0"
  sha256 "aee518b2c106492873f43583e96a14259e53e329fcfed4aa57b2bcbccb7cae23"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17.ttc"

  # No zap stanza required
end