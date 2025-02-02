cask "font-iosevka-aile" do
  version "32.5.0"
  sha256 "f4350298ba3a2cfbfdad8dd57cd67b9a33e45cfce2bc5864cff90f63e953b85c"

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