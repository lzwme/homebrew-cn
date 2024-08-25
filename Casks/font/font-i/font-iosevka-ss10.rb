cask "font-iosevka-ss10" do
  version "31.4.0"
  sha256 "498510e302ef24b70e7701642bb169407d15a33674f142c2b736223502e5c97b"

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