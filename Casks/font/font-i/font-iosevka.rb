cask "font-iosevka" do
  version "31.1.0"
  sha256 "781116f7a77de48e286b18292b2a746fda10aef5a7de6428a96fc7681c6ba0c3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-Iosevka-#{version}.zip"
  name "Iosevka"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Iosevka.ttc"

  # No zap stanza required
end