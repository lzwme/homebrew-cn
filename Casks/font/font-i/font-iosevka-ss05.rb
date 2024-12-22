cask "font-iosevka-ss05" do
  version "32.3.0"
  sha256 "9022679e56fe9d7097e4e1fa9a04bc1a419c4bd5642465fc9229c7736f3445d1"

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