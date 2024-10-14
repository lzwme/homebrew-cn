cask "font-iosevka-aile" do
  version "31.9.0"
  sha256 "0c512b46b36edc5d67002fe67d2b6aefeb7fa65093af200ce4447f396db3e231"

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