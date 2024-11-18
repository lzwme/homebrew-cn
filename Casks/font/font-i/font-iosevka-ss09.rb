cask "font-iosevka-ss09" do
  version "32.1.0"
  sha256 "95513c9c826b1733caae645bf959dd01caadb145348cf4ff40bdd2fc4e48c017"

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