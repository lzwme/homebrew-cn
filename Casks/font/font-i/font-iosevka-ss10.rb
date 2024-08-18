cask "font-iosevka-ss10" do
  version "31.3.0"
  sha256 "2ba9dae96493e84f24c16437fe625101168cdf4834a02caa8a1fca4f4a7a06d5"

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