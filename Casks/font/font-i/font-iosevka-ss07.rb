cask "font-iosevka-ss07" do
  version "32.4.0"
  sha256 "e146a3bc892a14a1cd949a0c64e2ddbcd2f2ad5f9767914fba4963d3211880f0"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end