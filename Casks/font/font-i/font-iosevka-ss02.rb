cask "font-iosevka-ss02" do
  version "31.9.0"
  sha256 "c445779c8a62339264102f661638a9efa48527add30e3835873fafe9f5d6091a"

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