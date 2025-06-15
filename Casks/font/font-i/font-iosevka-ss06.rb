cask "font-iosevka-ss06" do
  version "33.2.5"
  sha256 "6ce59d7b82d83996f1edc1777f78ba41b3bf1149346ddfe94ab4cea49fc6c5fb"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end