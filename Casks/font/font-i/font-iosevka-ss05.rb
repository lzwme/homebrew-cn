cask "font-iosevka-ss05" do
  version "33.2.5"
  sha256 "18f338de5113c8f6f438010a8784a1053138931e4fbc882ccf11b7179586ad61"

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