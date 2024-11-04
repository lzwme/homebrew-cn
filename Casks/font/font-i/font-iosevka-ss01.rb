cask "font-iosevka-ss01" do
  version "32.0.1"
  sha256 "3da4a23b65d07b79392b9964b86c6d9e757147c7fb0773e893e1be1d607218e1"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end