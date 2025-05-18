cask "font-iosevka-ss03" do
  version "33.2.3"
  sha256 "e67336059b2c14aa3d14643c6daf9564bd8e1c862182025ebf215da6e7e9dcde"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS03-#{version}.zip"
  name "Iosevka SS03"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS03.ttc"

  # No zap stanza required
end