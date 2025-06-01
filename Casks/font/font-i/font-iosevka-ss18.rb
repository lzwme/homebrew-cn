cask "font-iosevka-ss18" do
  version "33.2.4"
  sha256 "a84970853b1d92a9260d6421fd9bfb680b5d7c13b81924bfb19cde7c8ca825ac"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS18-#{version}.zip"
  name "Iosevka SS18"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS18.ttc"

  # No zap stanza required
end