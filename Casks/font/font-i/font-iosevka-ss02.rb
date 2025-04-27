cask "font-iosevka-ss02" do
  version "33.2.2"
  sha256 "f87f72b238036315babe72cf6150dda64ce9986523c20a37bfa63d2afeb8d49d"

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