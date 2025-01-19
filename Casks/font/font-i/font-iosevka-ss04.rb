cask "font-iosevka-ss04" do
  version "32.4.0"
  sha256 "37860687d2b6c8875f515ea0b25fbda536e034b73371c19ced6b2699f223c785"

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