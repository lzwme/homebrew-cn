cask "font-iosevka-ss10" do
  version "33.2.5"
  sha256 "42b94d00129be74c626e1c2bdb49b42c1d65a88e9dbf6f047eac5f6babe22142"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10.ttc"

  # No zap stanza required
end