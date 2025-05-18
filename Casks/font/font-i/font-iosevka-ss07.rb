cask "font-iosevka-ss07" do
  version "33.2.3"
  sha256 "a16a0ec1cb6c30e017ae706651a3f26b63be578386bf20312ca9d87e0565790b"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end