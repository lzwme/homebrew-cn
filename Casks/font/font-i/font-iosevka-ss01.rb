cask "font-iosevka-ss01" do
  version "33.2.3"
  sha256 "57c864d7d3e96a47ab438d40c5c12a5ae2a3884afa0f95afa3c58d43cea28001"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end