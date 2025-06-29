cask "font-iosevka" do
  version "33.2.6"
  sha256 "cdc5d97f4a417658ec24b85cb35621a79451a366afa28619b613e64d8f605cd9"

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