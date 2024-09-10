cask "font-iosevka-ss05" do
  version "31.6.1"
  sha256 "e7afea72a9d7aef462441a551465e9253bb3bd7336faad994ed46f24fff882de"

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