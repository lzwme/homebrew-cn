cask "font-iosevka-ss03" do
  version "33.2.1"
  sha256 "7d20c3bbc83e2bdd8a7135ce5cb2612530ce24074f0f16718042fd57064d3b59"

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