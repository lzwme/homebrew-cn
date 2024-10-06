cask "font-iosevka-ss08" do
  version "31.8.0"
  sha256 "59c6539a37cc936b7871a50ae056a9d3fe6286667911794354e8fbd3ac5ff2da"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end