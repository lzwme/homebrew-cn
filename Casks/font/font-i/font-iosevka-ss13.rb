cask "font-iosevka-ss13" do
  version "31.7.1"
  sha256 "d7de9217ca81054c4d43aeca77a7cf6dad9e177858c058a8b87cee3d60ababc9"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end