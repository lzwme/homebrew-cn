cask "font-iosevka-ss02" do
  version "31.5.0"
  sha256 "19f88983cc11ce5deb2d47fc1d2e2ba9e27c76876abbf4cec89bc9ee6a1b1b91"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS02-#{version}.zip"
  name "Iosevka SS02"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS02.ttc"

  # No zap stanza required
end