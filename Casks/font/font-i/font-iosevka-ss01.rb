cask "font-iosevka-ss01" do
  version "31.6.1"
  sha256 "0afec43faa51c0c0f7bc7c97904b05b196cf0d9c33fa51877b119d2076bf29cb"

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