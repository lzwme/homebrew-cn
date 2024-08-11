cask "font-iosevka-ss02" do
  version "31.2.0"
  sha256 "ff2830df5ee377df83251865312106d4783db66d4e94f201691341f378785908"

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