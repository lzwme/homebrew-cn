cask "font-iosevka-ss13" do
  version "31.4.0"
  sha256 "32daa71511db2d28e2cfa666e6822b8045829c48ec784bd1b94bf0ded65c5591"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end