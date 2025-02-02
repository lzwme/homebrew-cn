cask "font-iosevka-ss11" do
  version "32.5.0"
  sha256 "4038a70362ebea38b5380b0aded949467b6e4a2d6612e11d6e2221ca52e9ab00"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS11-#{version}.zip"
  name "Iosevka SS11"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS11.ttc"

  # No zap stanza required
end