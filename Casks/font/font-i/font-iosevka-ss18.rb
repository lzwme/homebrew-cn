cask "font-iosevka-ss18" do
  version "31.9.1"
  sha256 "82659495e411d1bbd8123c76d9162e678b62394952fbafe4174076ecbd87763d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS18-#{version}.zip"
  name "Iosevka SS18"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS18.ttc"

  # No zap stanza required
end