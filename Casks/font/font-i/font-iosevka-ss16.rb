cask "font-iosevka-ss16" do
  version "33.2.2"
  sha256 "d7a01bc0ba522ee7c5ba92e5d1b12bf35036638c6f1ce61538a6a17a7de0ab1c"

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