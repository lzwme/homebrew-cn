cask "font-iosevka-ss09" do
  version "33.2.1"
  sha256 "bce01150f81b8d322eaa9de00dfc793d47d85b8a4e6ef6f5ca1d4ee5bd824163"

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