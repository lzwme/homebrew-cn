cask "font-iosevka-ss10" do
  version "32.0.0"
  sha256 "50bc76672afefb9eedd73b93b4b11d300e0e9dc56f2d4f523d88c1ae9571392b"

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