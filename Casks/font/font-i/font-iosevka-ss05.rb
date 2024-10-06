cask "font-iosevka-ss05" do
  version "31.8.0"
  sha256 "13d1eaefa9de0cfee56623f595c80c8373818a59896f74930b5d557f3dad5a81"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end