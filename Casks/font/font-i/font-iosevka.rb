cask "font-iosevka" do
  version "31.8.0"
  sha256 "e50fec11065acda7b39ec69a5c8cbad61064d64037596961d3d30b74750a239b"

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