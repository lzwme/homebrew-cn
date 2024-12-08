cask "font-iosevka-aile" do
  version "32.2.1"
  sha256 "fb0d3f56b5524107f7c5f1d03eaedf0083644756783300b88a811f3977820ce4"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end