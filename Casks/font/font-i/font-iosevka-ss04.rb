cask "font-iosevka-ss04" do
  version "31.4.0"
  sha256 "d1d47252ace91d516e0c5c153cd4ab99a475c67e44549c99aa94a998124f93c5"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04.ttc"

  # No zap stanza required
end