cask "font-iosevka-ss09" do
  version "33.2.2"
  sha256 "13dee9751b848eac8b315817fc0a3b91077136de5334944133aedf305a91f57a"

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