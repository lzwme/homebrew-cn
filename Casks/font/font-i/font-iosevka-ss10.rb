cask "font-iosevka-ss10" do
  version "31.6.0"
  sha256 "261f33ce1ae8516aa6cb979a14ae855850a7b0fd2c7db7986f1c58377adddadd"

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