cask "font-iosevka-ss05" do
  version "32.0.0"
  sha256 "55affcd022a4d05aee936e8786993194fe985225d23de748e04e3baf670d0581"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end