cask "font-iosevka-aile" do
  version "32.4.0"
  sha256 "406b7bfb9d6469ab9036e6f7a1ee5bbe519cb3ba99554ab38e32210560ec696c"

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