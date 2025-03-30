cask "font-iosevka" do
  version "33.2.0"
  sha256 "881b42d2b43d5f287a5a6ae885f632800fb2ba3040d94fbf440e4009853d2a92"

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