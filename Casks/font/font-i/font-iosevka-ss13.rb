cask "font-iosevka-ss13" do
  version "31.2.0"
  sha256 "a8acc43b4bc92aae87ae57480c9303d09501ce558648b933cf25033e35ae436d"

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