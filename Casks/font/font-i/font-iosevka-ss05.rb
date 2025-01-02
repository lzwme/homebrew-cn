cask "font-iosevka-ss05" do
  version "32.3.1"
  sha256 "89e459b864e5351624b1354ff79ab49c2583c4bda606f00af31af0e419d901cb"

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