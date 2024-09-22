cask "font-iosevka-ss13" do
  version "31.7.0"
  sha256 "f853a1ff9419aa9dfe163b6429d848c8a35401d7acae2c36320a11117779c951"

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