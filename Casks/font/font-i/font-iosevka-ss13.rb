cask "font-iosevka-ss13" do
  version "31.9.1"
  sha256 "f5ad65107259644a1e8d549ecca0bad23ae0e58d16d5d6d060ed9cb32e079799"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end