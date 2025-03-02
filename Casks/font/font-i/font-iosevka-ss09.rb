cask "font-iosevka-ss09" do
  version "33.0.0"
  sha256 "71ebd05d02c824411f5018fed4e5302a70ddda02f4fa3e113ac8fb62c1f00503"

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