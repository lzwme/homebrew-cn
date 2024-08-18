cask "font-iosevka-ss09" do
  version "31.3.0"
  sha256 "5fbf0939ee5406543f1f44af50522125aa0904561e32a66b96141c2725d4d855"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS09-#{version}.zip"
  name "Iosevka SS09"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS09.ttc"

  # No zap stanza required
end