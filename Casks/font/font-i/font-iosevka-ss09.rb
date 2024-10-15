cask "font-iosevka-ss09" do
  version "31.9.1"
  sha256 "678489161cfb4edee128b809a13a1bbb11f9359dfbd0049effa7c415edf38056"

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