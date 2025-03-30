cask "font-iosevka-ss07" do
  version "33.2.0"
  sha256 "c7f93f23f57743f3f8a57e6666eecf6a51818b3b053d26f8b9969e80431a1808"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end