cask "font-iosevka-ss17" do
  version "33.1.0"
  sha256 "478929282eac7c66b157d355f3381087a732d537635aacab8396233d83c85ab1"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17.ttc"

  # No zap stanza required
end