cask "font-iosevka-ss01" do
  version "33.0.0"
  sha256 "11e9e5cfc539c136260ddc625887c83a6073abb9c24aad06432f0b501ca0d5ed"

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