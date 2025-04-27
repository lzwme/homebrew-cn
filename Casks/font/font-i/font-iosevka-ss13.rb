cask "font-iosevka-ss13" do
  version "33.2.2"
  sha256 "bf870681cc82a9fc0614d58320c753632795871a66443cc349dd351178dd0fd4"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end