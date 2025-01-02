cask "font-iosevka-ss03" do
  version "32.3.1"
  sha256 "72214770c6763d79a5c55869e0d42a4085252fa1110ba8da1c7d789ba00750af"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS03-#{version}.zip"
  name "Iosevka SS03"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS03.ttc"

  # No zap stanza required
end