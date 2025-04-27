cask "font-iosevka-ss10" do
  version "33.2.2"
  sha256 "02fb2762f61706b0f5ee1a3259ff66822f93e454f326b80cd7271a84e33d1429"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10.ttc"

  # No zap stanza required
end