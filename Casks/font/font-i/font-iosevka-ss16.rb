cask "font-iosevka-ss16" do
  version "33.2.0"
  sha256 "8c4fd4fe68155e329a1a9c0686e80ce8797f55eee1083db583aeefa0140af08e"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS16-#{version}.zip"
  name "Iosevka SS16"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS16.ttc"

  # No zap stanza required
end