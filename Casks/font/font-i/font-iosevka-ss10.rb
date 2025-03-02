cask "font-iosevka-ss10" do
  version "33.0.0"
  sha256 "35e1de935193aaeda93de4c7850c707fe55c27917ef581dffcfe59f74426d2bd"

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