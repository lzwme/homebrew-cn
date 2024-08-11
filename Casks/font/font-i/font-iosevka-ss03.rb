cask "font-iosevka-ss03" do
  version "31.2.0"
  sha256 "73d2d1b0d4b28d70c44342a2d6c3acf0884262f31973f01b1edd3b40a3146d40"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS03-#{version}.zip"
  name "Iosevka SS03"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS03.ttc"

  # No zap stanza required
end