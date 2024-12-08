cask "font-iosevka-ss10" do
  version "32.2.1"
  sha256 "ce0002e5e63bf3e9e1095d8239b711c05a30607c34c554771d66ba57f0a517c3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10.ttc"

  # No zap stanza required
end