cask "font-iosevka-ss06" do
  version "33.2.1"
  sha256 "31ff3603d2b7b9028463b0f4736cbce55d4f8b85c0804ad72b53ed82db64bec2"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end