cask "font-iosevka-ss08" do
  version "32.3.1"
  sha256 "4be15dee0ba7dbbac39ea396ffb2fa6ee560d0bfa44ae0c6f540c5149306fb81"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end