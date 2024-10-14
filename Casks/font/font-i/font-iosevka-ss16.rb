cask "font-iosevka-ss16" do
  version "31.9.0"
  sha256 "0aa83292eb591845258400ce79fc37f9358eaafb8b718e4b04d66507dab34497"

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