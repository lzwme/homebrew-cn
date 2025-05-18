cask "font-iosevka-ss09" do
  version "33.2.3"
  sha256 "938ce7ce8f4ff2ea4a0f5143d33b30a9463281142443176d0f57526589219a07"

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