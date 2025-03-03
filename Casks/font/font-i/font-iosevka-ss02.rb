cask "font-iosevka-ss02" do
  version "33.0.1"
  sha256 "2efb66d2a076022acaf4cb506a5a80419864c2598bf420d9b7c7f3ba2d7e4a26"

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