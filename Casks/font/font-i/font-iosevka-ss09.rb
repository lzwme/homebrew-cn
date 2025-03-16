cask "font-iosevka-ss09" do
  version "33.1.0"
  sha256 "2423c24e103fe1530ed3c828fcf9e03c62b3b88e18540f013c9c4a953bd4b2ec"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS09-#{version}.zip"
  name "Iosevka SS09"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS09.ttc"

  # No zap stanza required
end